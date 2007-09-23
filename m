Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbXIWTZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbXIWTZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 15:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbXIWTZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 15:25:19 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4870 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbXIWTZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 15:25:18 -0400
Subject: Re: [RFC] New kernel-message logging API
From: Joe Perches <joe@perches.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, holzheu <holzheu@linux.vnet.ibm.com>,
       Rob Landley <rob@landley.net>,
       Dick Streefland <dick.streefland@altium.nl>
In-Reply-To: <19f34abd0709230139s56b9a9b1yc2cae89488ea5112@mail.gmail.com>
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
	 <1190506383.30132.11.camel@localhost>
	 <19f34abd0709230139s56b9a9b1yc2cae89488ea5112@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 23 Sep 2007 12:25:15 -0700
Message-Id: <1190575516.30132.48.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-23 at 10:39 +0200, Vegard Nossum wrote:
> On 9/23/07, Joe Perches <joe@perches.com> wrote:
> > Given the number of 80 column zealots, character naming length
> > matters.
> I don't know. Compare the following two lines:
> printk(KERN_INFO "Message.\n");
> kprint_info("Message.");

The problem isn't printk(KERN_<level> to kprint_<level>(.

The problems are the no level printk(foo)s to kprint_<level>(foo)
and the pr_<level>() to kprint_<level>() translations.

> By dropping the lengthy macro (it's not like it's going to change
> while we're running anyway, so why not make it a part of the function
> name?) and the final newline, we actually end up with a net decrease
> in line length.

Which I do appreciate and think good.

> I thought it would be nice to have something that looks familiar,
> since that would ease an eventual transition. klog is a valid
> alternative, but isn't kp a bit cryptic?

Probably no more than pr_<level> is today.

cheers, Joe

