Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbXKFXCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbXKFXCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 18:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756285AbXKFXA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 18:00:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55902 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277AbXKFXA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 18:00:27 -0500
Date: Tue, 6 Nov 2007 23:00:26 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix writing to unintended memory in eth16i_probe_port(); drivers/net/eth16i.c
Message-ID: <20071106230026.GL8181@ftp.linux.org.uk>
References: <4730F168.4010203@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4730F168.4010203@tiscali.nl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 11:57:44PM +0100, Roel Kluin wrote:
> 14 is added as an offset to the array dummy_packet (64 unsigned chars) to
> serve as a destination address in a call to memset(). However, when added, 
> it is automatically scaled by the size of dummy_packet, which is 64. This
> results in writing to unintended memory.

NAK.  Learn C.
