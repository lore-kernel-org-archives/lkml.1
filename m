Return-Path: <linux-kernel-owner+w=401wt.eu-S933155AbZJaTJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155AbZJaTJq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 15:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933134AbZJaTJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 15:09:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58874 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933114AbZJaTJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 15:09:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ferenc Wagner <wferi@niif.hu>
Subject: Re: [linux-pm] intermittent suspend problem again
Date: Sat, 31 Oct 2009 20:11:03 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       linux-pm@lists.linux-foundation.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, yakui.zhao@intel.com,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <9b2b86520910310502p7fe8e0edmff09220632fab5e2@mail.gmail.com> <874opfwtde.fsf@tac.ki.iif.hu>
In-Reply-To: <874opfwtde.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910312011.04005.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 October 2009, Ferenc Wagner wrote:
> Alan Jenkins <sourcejedi.lkml@googlemail.com> writes:
> 
> > On 10/30/09, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> On Friday 30 October 2009, Ferenc Wagner wrote:
> >>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >>>
> >>>> On Thursday 29 October 2009, Ferenc Wagner wrote:
> >>>>
> >>>>> and saving the image as well.  If s2disk didn't report funny huge
> >>>>> negative ratios all the time,
> >>>>
> >>>> Hmm.  This looks like a bug in s2disk.
> >>>
> >>> Definitely.  Do you also experience this?
> >>
> >> Not really, but I use newer versions.
> >>
> >>> Probably an easy one, but I've never had the chance to check the CVS
> >>> version (running 0.7 at the moment).  I can probably give 0.8 a spin
> >>> if you deem necessary.  I always thought it wasn't more than a
> >>> cosmetic flaw.
> >>
> >> It probably is.  You can try the current version from my git tree at:
> >> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-utils.git
> >
> > I seem to recall reporting this and finding that the latest version
> > fixed the bug simply by removing the code which printed the ratio :-).
> 
> Heh, maybe, but the version compiled from Rafael's git tree prints the
> ratio all right, and its value is even positive and less than 1.  So I
> confirm that the ratio issue is fixed.  I'll be running with this
> version from now on, and if it exhibits the same original issue, I'll
> switch to shutdown mode and gather some experience running that.

Well, the problem you reported is a kernel issue and switching to the newer
user space is not likely to help.

Best,
Rafael
