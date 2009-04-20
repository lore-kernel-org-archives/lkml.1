Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZDTTrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZDTTrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 15:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbZDTTr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 15:47:29 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42991 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671AbZDTTr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 15:47:28 -0400
Date: Mon, 20 Apr 2009 12:47:23 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Gary Hade <garyhade@us.ibm.com>, mingo@elte.hu, mingo@redhat.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG from text_poke() during CPU offlining
Message-ID: <20090420194723.GB7106@us.ibm.com>
References: <20090408201107.GA11159@us.ibm.com> <49DD073E.4050804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DD073E.4050804@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 01:21:18PM -0700, Masami Hiramatsu wrote:
> Hi Gary,
> 
> Gary Hade wrote:
> > I ran into the below BUG with 32-bit 2.6.30-rc1 while offlining
> > all of the offlineable CPUs.  It happened when the last offlineable
> > CPUs was being offlined.  The problem disappeared after I reverted
> > the following two patches.
> >  - x86: implement atomic text_poke() via fixmap
> >    http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=78ff7fae04554b49d29226ed12536268c2500d1f
> >  - x86: expand irq-off region in text_poke()
> >    http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7cf49427042400d40bdc80b5c3399b6b5945afa8
> 
> Hmm, this bug seems that the same bug I reported recently.
> 
> http://lkml.org/lkml/2009/4/4/71
> 
> I'm working on that.

Masami,
Just confirming that I can no longer reproduce the problem with
2.6.30-rc2 which includes your fix (http://lkml.org/lkml/2009/4/10/346).

> 
> Thank you for reporting!

Thank you for fixing!

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
