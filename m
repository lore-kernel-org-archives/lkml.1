Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbZJFAGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbZJFAGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbZJFAGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:06:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49639 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278AbZJFAGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:06:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] 2.6.32-rc1: various BUGs on resume from hibernation
Date: Tue, 6 Oct 2009 02:06:49 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-rjw; KDE/4.3.1; x86_64; ; )
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Stefan Seyfried <stefan.seyfried@googlemail.com>
References: <4AC8B4A8.3050601@tuffmail.co.uk> <4ACA5E3D.1020108@tuffmail.co.uk> <200910060048.41615.rjw@sisk.pl>
In-Reply-To: <200910060048.41615.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910060206.49500.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 October 2009, Rafael J. Wysocki wrote:
> On Monday 05 October 2009, Alan Jenkins wrote:
> > Alan Jenkins wrote:
> > > Stefan Seyfried wrote:
> > >> On Sun, 4 Oct 2009 22:47:43 +0200
> > >> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > >>> On Sunday 04 October 2009, Alan Jenkins wrote:
> > >>>> Alan Jenkins wrote:
> > >>>>> I'm seeing a variety of BUGs on my EeePC 701 after hibernation. 
> > >>>>> Sometimes they cause a hang during resume; sometimes they happen
> > >>>>> just after resume. It doesn't happen all the time either - I've
> > >>>>> just hibernated three times in a row with no problems. It's most
> > >>>>> perplexing.
> > >>
> > >>> As I already asked in the Bugzilla, can you verify that this is
> > >>> reproducible without KMS?
> > >
> > > No. I couldn't reproduce it without KMS. Then I re-enabled KMS, 
> > > hibernated a couple of times, and had another resume hang (different 
> > > again - this time in the freezer).
> > >
> > 
> > Perhaps this GEM backtrace is more relevant than the others, or perhaps 
> > not. I closed the lid during resume from hibernation; the screen stayed 
> > black when I re-opened it, but syslogd recorded the following. (Again, 
> > I've done the exact thing before and often nothing unusual happens) -
> 
> OK, let's assume it's related to KMS, then.
> 
> 1. Do we already have a Bugzilla entry for it?

Ah, yes, we do, http://bugzilla.kernel.org/show_bug.cgi?id=14320 (I tend to
forget about these things).

> 2. Did it work with 2.6.31 (and with KMS)?
> 3. Are you aware of http://marc.info/?l=linux-kernel&m=125452324520623&w=4 ?

Thanks,
Rafael
