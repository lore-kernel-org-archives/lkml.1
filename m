Return-Path: <linux-kernel-owner+w=401wt.eu-S965519AbXCPQeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965519AbXCPQeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965512AbXCPQeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:34:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3017 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933626AbXCPQds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:33:48 -0400
Date: Fri, 16 Mar 2007 16:21:17 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.21rc suspend to ram regression on Lenovo X60
Message-ID: <20070316162117.GA3951@ucw.cz>
References: <20070313040828.GA17893@redhat.com> <m1wt1ltveu.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wt1ltveu.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Seeing a couple of MSI changes in there, on a hunch I booted latest tree with
> > pci=nomsi, and it resumed again.
> >
> > Any ideas how to further debug this?
> > I'll try backing out individual changes from that merge tomorrow.
> 
> Thanks.  
> 
> Of those msi patches you have identified I don't see anything really
> obvious.  And you actually marked them as good in your bisect so
> I don't expect it is core problem.
> 
> We do have a known e1000 regression, with msi and suspend/resume.
> So it is possible the nomsi avoided a driver problem.  Especially
> as we have a number of driver changes on the on Linus's side of
> that merge.
> 
> I also know we have some known issues with pci_save_state and
> pci_restore_state that require them to be paired for correct
> operation.  For suspend and resume that is not generally a problem.
> 
> I have fixes for the pci_save_state and pci_restore_state in the -mm
> and gregkh tree's.  Since they also happen to fix the e1000 driver as
> a side effect they are worth looking at, at least if you have an
> e1000.
> 
> I don't have a clue which hardware the x60 has so I don't know which
> drivers it would be using.

x60 indeed has e1000.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
