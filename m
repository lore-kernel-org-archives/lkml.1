Return-Path: <linux-kernel-owner+w=401wt.eu-S1762956AbYBWUZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762956AbYBWUZj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 15:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757092AbYBWUZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 15:25:29 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:35975 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677AbYBWUZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 15:25:28 -0500
Message-ID: <47C08134.2030205@garzik.org>
Date: Sat, 23 Feb 2008 15:25:24 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] scsi fixes for 2.6.25-rc2
References: <1203779614.3139.4.camel@localhost.localdomain>
In-Reply-To: <1203779614.3139.4.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> This is the latest crop of bug fixes plus one new driver: mvsas.  We're
[...]
> Jeff Garzik (1):
>       mvsas: Add Marvell 6440 SAS/SATA driver
[...]
> Ke Wei (1):
>       mvsas: convert from rough draft to working driver


I know I am probably shooting myself in the foot here, since I am the 
original author of mvsas, but...

Should we be adding new drivers during -rc?

On one hand, it's clear the addition does not break anything, and adds 
value for users.

On the other hand, it's clearly not a bug fix, and -rc could easily get 
bloated with new drivers that didn't make the merge window.

On the net driver side of things, I have a few new net drivers that I 
have queued for 2.6.26, because they did not make the merge window. 
This is inconsistent with your apparently policy.

I would just prefer to have a clear and consistent policy here, 
regarding new drivers during -rc.

Thanks,

	Jeff


