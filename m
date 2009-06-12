Return-Path: <linux-kernel-owner+w=401wt.eu-S1765664AbZFLWov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765664AbZFLWov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763507AbZFLWoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:44:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60155 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764303AbZFLWn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:43:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.31
Date: Sat, 13 Jun 2009 00:44:09 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Lauro Salmito <laurosalmito@gmail.com>, Magnus Damm <damm@igel.co.jp>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Sergio Luis <sergio@larces.uece.br>
References: <200906122202.08345.rjw@sisk.pl> <alpine.LFD.2.01.0906121317320.3237@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906121317320.3237@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906130044.11273.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 June 2009, Linus Torvalds wrote:
> 
> On Fri, 12 Jun 2009, Rafael J. Wysocki wrote:
> 
> > Hi Linus,
> > 
> > Please pull power management updates for 2.6.31 from:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus
> > 
> > They are cleanups and code rearrangements mostly, in particular:
> > 
> > * arch/x86/power/cpu_(32|64) unification from Sergio Luis (Ingo saw
> >   these patches and his opinion was that they should better go
> >   through the suspend tree)
> > 
> > * Removal of some unused files and PM callbacks, function renames
> >   from Magnus Damm and Alan Stern
> > 
> > * Rearrangements of the code under kernel/power from me and
> >   Cornelia Huck
> > 
> > * Two patches related to the memory shrinking (for the record, Pavel
> >   doesn't like the "PM/Suspend: Do not shrink memory before suspend"
> >   patch, so please let me know if I should drop it)
> > 
> > * A couple of bug fixes
> > 
> > 
> >  arch/x86/power/cpu.c             |  259 +++++++++++
> >  arch/x86/power/cpu_32.c          |  148 ------
> >  arch/x86/power/cpu_64.c          |  174 -------
> >  kernel/power/disk.c              |  955 --------------------------------------
> >  kernel/power/hibernate.c         |  955 ++++++++++++++++++++++++++++++++++++++
> >  kernel/power/hibernate_nvs.c     |  135 ++++++
> >  35 files changed, 2056 insertions(+), 2194 deletions(-)
> 
> Please add rename detection to your pull script (and --summary, for that 
> matter). This _should_ have looked like
> 
>  33 files changed, 984 insertions(+), 1122 deletions(-)
> 
> because it would have detected this:
> 
>  rename arch/x86/power/{cpu_64.c => cpu.c} (62%)
>  delete mode 100644 arch/x86/power/cpu_32.c
>  rename kernel/power/{disk.c => hibernate.c} (96%)
> 
> instead of counting those as some huge patches that add/remove code.

I will, sorry for not doing it this time and thanks for pulling.

Best,
Rafael
