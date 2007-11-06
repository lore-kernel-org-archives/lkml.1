Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbXKFXRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbXKFXRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 18:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbXKFXQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 18:16:53 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:34065 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbXKFXQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 18:16:53 -0500
Message-ID: <4730F5E1.30401@tiscali.nl>
Date: Wed, 07 Nov 2007 00:16:49 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix writing to unintended memory in eth16i_probe_port();
 drivers/net/eth16i.c
References: <4730F168.4010203@tiscali.nl> <20071106230026.GL8181@ftp.linux.org.uk>
In-Reply-To: <20071106230026.GL8181@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Tue, Nov 06, 2007 at 11:57:44PM +0100, Roel Kluin wrote:
>> 14 is added as an offset to the array dummy_packet (64 unsigned chars) to
>> serve as a destination address in a call to memset(). However, when added, 
>> it is automatically scaled by the size of dummy_packet, which is 64. This
>> results in writing to unintended memory.
> 
> NAK.  Learn C.
> 
yeah I read your other mail, was going to reply myself anyway, but hey, you
had to be rude again.
