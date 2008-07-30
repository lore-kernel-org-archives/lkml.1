Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbYG3Qjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbYG3Qjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 12:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbYG3Qji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 12:39:38 -0400
Received: from em-p00-ob.rzone.de ([81.169.146.225]:37453 "EHLO
	em-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbYG3Qjh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 12:39:37 -0400
X-RZG-CLASS-ID: em00
Date: Wed, 30 Jul 2008 18:39:35 +0200 (MEST)
Message-Id: <200807301639.m6UGdZwq013261@post.webmailer.de>
To: linux-kernel@vger.kernel.org
From: c4p7n1@capitanio.org
Subject: Re: kernel bug (null pointer) in 2.6.27-rc1
X-Priority: 3
X-Abuse: 383041 / 79.220.227.87
X-RZG-MBID: 1GeNaoUet6Qfjg==
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Di, 29 Jul 2008, Ryan Hope wrote:
> > This patch fixes this issue, it fixed it for me:
> 
> Thanks, although that ...
> 
> > -static SYSDEV_ATTR(sched_smt_power_savings, 0644,
> sched_smt_power_savings_show,
> > -		   sched_smt_power_savings_store);
> > +static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644,
> > +                    sched_smt_power_savings_show,
> >  #endif
> 
> Seems to be bogus and produced a
> 	kernel/sched.c:9137:1: error: unterminated argument list
> 	invoking macro "SYSDEV_CLASS_ATTR"
> Hopefully not in the kernel ...
> 
Reverting "sysdev: Pass the attribute to the low level sysdev show/store function"
4a0b2b4dbe1335b8b9886ba3dc85a145d5d938ed
helps here.

Martin Capitanio
