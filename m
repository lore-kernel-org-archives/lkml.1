Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbXKFXPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbXKFXPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 18:15:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbXKFXOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 18:14:52 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:52808 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934AbXKFXOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 18:14:51 -0500
Message-ID: <4730F568.3080901@tiscali.nl>
Date: Wed, 07 Nov 2007 00:14:48 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix writing to unintended memory in pkt_generic_packet();
 drivers/block/pktcdvd.c
References: <4730EE00.8040809@tiscali.nl> <20071106225012.GK8181@ftp.linux.org.uk>
In-Reply-To: <20071106225012.GK8181@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Tue, Nov 06, 2007 at 11:43:12PM +0100, Roel Kluin wrote:
>> CDROM_PACKET_SIZE is added as an offset to the pointer to unsigned char cmd[16].
>> The adjusted pointer is then used as a destination address in a call to
>> memset(). However, when CDROM_PACKET_SIZE is added to the pointer, it is
>> automatically scaled by the size of cmd, which is 16. This results in the call
>> to memset() writing to unintended memory.
> 
> What are you talking about?  rq->cmd is an array, not a pointer to array.
> When it occurs as an argument of +, it decays to pointer to array element.

Ok, I misunderstood, but please...

> Please, learn C.

That's not a nice thing to say.
