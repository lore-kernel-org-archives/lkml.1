Return-Path: <linux-kernel-owner+w=401wt.eu-S1764138AbYARSms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764138AbYARSms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760081AbYARSmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:42:39 -0500
Received: from waste.org ([66.93.16.53]:56676 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759676AbYARSmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:42:38 -0500
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk
From: Matt Mackall <mpm@selenic.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, daniel.ritz-ml@swissonline.ch,
       randy.dunlap@oracle.com, jeff@garzik.org, linux-ide@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
In-Reply-To: <1200445210549-git-send-email-htejun@gmail.com>
References: <1200445210549-git-send-email-htejun@gmail.com>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 12:41:08 -0600
Message-Id: <1200681668.25782.9.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-16 at 10:00 +0900, Tejun Heo wrote:
> And mprintk the following.
> 
>  code:
>   DEFINE_MPRINTK(mp, 2 * 80);
> 
>   mprintk_set_header(&mp, KERN_INFO "ata%u.%2u: ", 1, 0);
>   mprintk_push(&mp, "ATA %d", 7);
>   mprintk_push(&mp, ", %u sectors\n", 1024);
>   mprintk(&mp, "everything seems dandy\n");

I prefer Matthew Wilcox's stringbuf approach which does proper memory
management and isn't specific to printk:

http://www.ussg.iu.edu/hypermail/linux/kernel/0710.3/0517.html

-- 
Mathematics is the supreme nostalgia of our time.

