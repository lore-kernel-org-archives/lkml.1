Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbZHFPGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbZHFPGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZHFPGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:06:42 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:44450 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753573AbZHFPGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:06:41 -0400
X-Greylist: delayed 1201 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Aug 2009 11:06:40 EDT
Subject: Re: [ANNOUNCE] 2.6.31-rc4-rt1 (problem with
 CONFIG_SYSFS_DEPRECATED_V2)
From: Sven-Thorsten Dietrich <sdietrich@novell.com>
To: Clark Williams <williams@redhat.com>
Cc: gowrishankar.m@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Jon Masters <jcm@redhat.com>
In-Reply-To: <20090806093628.216bb27f@torg>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904251500150.4529@localhost.localdomain>
	 <alpine.LFD.2.00.0904290036500.4529@localhost.localdomain>
	 <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain>
	 <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>
	 <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain>
	 <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain>
	 <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain>
	 <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>
	 <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain>
	 <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
	 <4A79214B.5070003@linux.vnet.ibm.com> <20090805083247.0b84d1c0@torg>
	 <4A7A7C37.7020609@linux.vnet.ibm.com>  <20090806093628.216bb27f@torg>
Content-Type: text/plain
Organization: Novell
Date: Thu, 06 Aug 2009 07:46:25 -0700
Message-Id: <1249569985.6772.3.camel@quadrophenia.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 09:36 -0500, Clark Williams wrote:
> On Thu, 06 Aug 2009 12:16:15 +0530
> gowrishankar <gowrishankar.m@linux.vnet.ibm.com> wrote:
> 
> > Only if I set CONFIG_SYSFS_DEPRECATED_V2=y, I could successfully boot
> > which I have tested with this kernel in same system.
> > 
> > Is it not set by default from 2.6.31 onwards ?
> > 
> > Thanks,
> > Gowri
> 
> I wasn't sure when it would move from 'y' to 'n', but looks like .31 is
> it. You'll need that option back on for booting on RHEL (since the boot
> infrastructure uses the old /sys format) but I don't think you'll need
> it for Fedora. Not sure about SLERT. Bet Greg Haskins would know
> though :)
> 

You need it Y to boot on SLES 10 / SLERT 10 file systems. 

Its ok with 'N' on openSUSE 10.3 or later.

Sven

> Clark

