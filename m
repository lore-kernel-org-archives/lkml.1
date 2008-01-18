Return-Path: <linux-kernel-owner+w=401wt.eu-S1764694AbYARSpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764694AbYARSpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762647AbYARSpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:45:00 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:35223 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761461AbYARSo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:44:59 -0500
Date: Fri, 18 Jan 2008 11:44:57 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Matt Mackall <mpm@selenic.com>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       daniel.ritz-ml@swissonline.ch, randy.dunlap@oracle.com, jeff@garzik.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk
Message-ID: <20080118184457.GC20490@parisc-linux.org>
References: <1200445210549-git-send-email-htejun@gmail.com> <1200681668.25782.9.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200681668.25782.9.camel@cinder.waste.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 12:41:08PM -0600, Matt Mackall wrote:
> On Wed, 2008-01-16 at 10:00 +0900, Tejun Heo wrote:
> > And mprintk the following.
> > 
> >  code:
> >   DEFINE_MPRINTK(mp, 2 * 80);
> > 
> >   mprintk_set_header(&mp, KERN_INFO "ata%u.%2u: ", 1, 0);
> >   mprintk_push(&mp, "ATA %d", 7);
> >   mprintk_push(&mp, ", %u sectors\n", 1024);
> >   mprintk(&mp, "everything seems dandy\n");
> 
> I prefer Matthew Wilcox's stringbuf approach which does proper memory
> management and isn't specific to printk:
> 
> http://www.ussg.iu.edu/hypermail/linux/kernel/0710.3/0517.html

Do you have any strong feelings whether we should merge my stringbufs or
rusty's version?  I have no particular preference.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
