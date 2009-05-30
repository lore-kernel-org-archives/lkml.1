Return-Path: <linux-kernel-owner+w=401wt.eu-S1761630AbZE3MNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761630AbZE3MNd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 08:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756883AbZE3MNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 08:13:25 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:36164 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbZE3MNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 08:13:24 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [GIT PULL] x86 fixes for 2.6.30-rc8
Date: Sat, 30 May 2009 07:13:21 -0500
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Thomas Gleixner <tglx@linutronix.de> Suresh Siddha" 
	<suresh.siddha@intel.com>,
       Tejun Heo <tj@kernel.org>,
       Venkatesh Pallapadi <venkatesh.pallapadi@intel.com>,
       Zhang Rui <rui.zhang@intel.com>
References: <200905252003.n4PK3sFi014919@voreg.hos.anvin.org> <20090530112234.GB1395@ucw.cz>
In-Reply-To: <20090530112234.GB1395@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905300713.23741.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat May 30 2009, Pavel Machek wrote:
> Hi!
> 
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -1535,6 +1535,10 @@ and is between 256 and 4096 characters. It is defined in the file
> >  			register save and restore. The kernel will only save
> >  			legacy floating-point registers on task switch.
> >  
> > +	noxsave		[BUGS=X86] Disables x86 extended register state save
> > +			and restore using xsave. The kernel will fallback to
> > +			enabling legacy floating-point and sse state.
> > +
> 
> Does that mean apps using sse8 will see their registers corrupted if
> this option is used? Or are new registers sets always added in a way
> that kernel has to enable them first?
> 

Has this change been tested on the processors that have independent ftp&sse
units, without the shared registers?  Such as the VIA C7-M?

Mike
