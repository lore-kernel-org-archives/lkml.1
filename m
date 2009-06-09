Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbZFIXTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbZFIXTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 19:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbZFIXTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 19:19:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44076 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbZFIXTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 19:19:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [Bug #13116] Can't boot with nosmp
Date: Wed, 10 Jun 2009 01:19:36 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Avi Kivity <avi@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <4A2EAD2F.5010505@redhat.com> <20090609135846.43260595@nehalam>
In-Reply-To: <20090609135846.43260595@nehalam>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906100119.37479.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009, Stephen Hemminger wrote:
> On Tue, 09 Jun 2009 21:42:55 +0300
> Avi Kivity <avi@redhat.com> wrote:
> 
> > Stephen Hemminger wrote:
> > 
> >   
> > 
> > >> This only affects reboots.  But yes, the cpumask code has bugs.  Does 
> > >> the .config involved select MAXSMP?
> > >>
> > >>     
> > >
> > > Patch does not fix the problem. Not sure if it is KVM only problem.
> > > Look like possible cpumask always equals what ACPI / SMP tables report.
> > > So currently looking into alloc_percpu which may not handle the possible
> > > but never used cpus.
> > >
> > >   
> > 
> > Right, it shouldn't have.
> > 
> > > It is x86-64 config and does not have MAXSMP set. It does have NR_CPUS set.
> > >   
> > 
> > So it's not cpumask.  Dare I suggest a bisect?
> > 
> 
> I did some testing of different versions.
> 
> * Problem does not exist with 2.6.30-rc8 (so regression should be closed).

Done.

Thanks,
Rafael
