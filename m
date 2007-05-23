Return-Path: <linux-kernel-owner+w=401wt.eu-S1760870AbXEWPzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870AbXEWPzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbXEWPyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:54:55 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:35308 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861AbXEWPyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:54:54 -0400
Date: Wed, 23 May 2007 19:53:41 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: Review status (Re: [PATCH] LogFS take three)
Message-ID: <20070523155339.GA17753@2ka.mipt.ru>
References: <20070515151919.GA32510@lazybastard.org> <20070515152149.GB32059@lazybastard.org> <20070517160308.GA26643@2ka.mipt.ru> <20070517171017.GB15676@lazybastard.org> <20070520173049.GA20907@2ka.mipt.ru> <20070523125840.GC24738@lazybastard.org> <20070523150732.GA2456@2ka.mipt.ru> <20070523151402.GA25532@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070523151402.GA25532@lazybastard.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Wed, 23 May 2007 19:53:56 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 05:14:04PM +0200, Jörn Engel (joern@lazybastard.org) wrote:
> > > I'm just a German.  Forgive me if I drink lesser beverages.
> > 
> > You should definitely change that.
> 
> Change being German?  Not a bad idea, actually.

You cook up really tasty shnaps, in small quantities it is good for
health in infinite volumes.

> > Btw, what about this piece:
> > 
> > int logfs_erase_segment(struct super_block *sb, u32 index)
> > {
> > 	struct logfs_super *super = LOGFS_SUPER(sb);
> > 
> > 	super->s_gec++;
> > 
> > 	return mtderase(sb, index << super->s_segshift, super->s_segsize);
> > }
> > 
> > index << super->s_segshift might overflow, mtderase expects loff_t
> > there, since index can be arbitrary segment number, is it possible, that
> > overflow really occurs?
> 
> Indeed it is.  You just earned your second beer^Wvodka.

Actually this code looks less encrypted than ext2 for, which definitely
a good sign from reviewer's point of view.

> Jörn

-- 
	Evgeniy Polyakov
