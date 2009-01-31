Return-Path: <linux-kernel-owner+w=401wt.eu-S1755731AbZAaTYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbZAaTYX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 14:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZAaTYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 14:24:16 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:59787 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbZAaTYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 14:24:15 -0500
Message-ID: <4984A556.5040607@garzik.org>
Date: Sat, 31 Jan 2009 14:24:06 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: stable@kernel.org, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: For -stable: sata_mv: fix 8-port timeouts on 508x/6081 chips
References: <20090131023906.GA12147@kroah.com> <4983BE2B.90805@rtr.ca>
In-Reply-To: <4983BE2B.90805@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> commit b0bccb18bc523d1d5060d25958f12438062829a9
> Author: Mark Lord <liml@rtr.ca>
> Date:   Mon Jan 19 18:04:37 2009 -0500
> 
>    sata_mv: fix 8-port timeouts on 508x/6081 chips
>       Fix a longstanding bug for the 8-port Marvell Sata controllers 
> (508x/6081),
>    where accesses to the upper 4 ports would cause lost-interrupts / 
> timeouts
>    for the lower 4-ports.  With this patch, the 6081 boards should 
> finally be
>    reliable enough for mainstream use with Linux.
>       Signed-off-by: Mark Lord <mlord@pobox.com>
>    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> 
> 
> This should be backported to all -stable kernels.

ACK / agreed



