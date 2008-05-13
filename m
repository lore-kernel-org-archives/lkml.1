Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbYEMTQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbYEMTQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 15:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbYEMTQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 15:16:34 -0400
Received: from lazybastard.de ([212.112.238.170]:57504 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbYEMTQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 15:16:33 -0400
Date: Tue, 13 May 2008 21:16:16 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-mtd@lists.infradead.org, Bryan Wu <cooloney@kernel.org>,
       dwmw2@infradead.org, will.newton@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [MTD/MAPS] Blackfin Async Flash Maps: Handle the case where flash memory and ethernet mac/phy are mapped onto the same async bank
Message-ID: <20080513191616.GC18026@logfs.org>
References: <1210653525-19437-1-git-send-email-cooloney@kernel.org> <20080513080727.GA15795@logfs.org> <8bd0f97a0805130542x46f5e7fejf1347f1c71f567fb@mail.gmail.com> <20080513150143.GA18026@logfs.org> <8bd0f97a0805130815q2ffa1d34ue87f5eb1422b6f42@mail.gmail.com> <20080513153441.GB18026@logfs.org> <8bd0f97a0805131042x2a74115dqc3831a604583bbd5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0805131042x2a74115dqc3831a604583bbd5@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 13:42:04 -0400, Mike Frysinger wrote:
> On Tue, May 13, 2008 at 11:34 AM, Jörn Engel <joern@logfs.org> wrote:
> > On Tue, 13 May 2008 12:38:45 +0800, Bryan Wu wrote:
> > > +#define pr_devinit(fmt, args...) ({ static const __devinitdata char __fmt[] = fmt; printk(__fmt, ## args); })
> >
> >  That bit is obvious.  But why do you use pr_devinit() instead of
> >  printk()?  What does it gain you?
> 
> why do we have __init and __devinit in the first place ?

Ah.  Now I finally understand what this code does.

Might be worth moving it to include/linux/kernel.h, along with
pr_init().  And watch an avalanche of janitor patches use these new
toys. :)

Jörn

-- 
Joern's library part 3:
http://inst.eecs.berkeley.edu/~cs152/fa05/handouts/clark-test.pdf
