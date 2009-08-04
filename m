Return-Path: <linux-kernel-owner+w=401wt.eu-S933043AbZHDQ1C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043AbZHDQ1C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:27:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933027AbZHDQ1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:27:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48109 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933025AbZHDQ06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:26:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [Regression] Hibernation failure on dual core Athlon 64 (64-bit)
Date: Tue, 4 Aug 2009 18:27:37 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>
References: <200908032303.57859.rjw@sisk.pl> <20090803222359.GA3770@Krystal>
In-Reply-To: <20090803222359.GA3770@Krystal>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908041827.38547.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 August 2009, Mathieu Desnoyers wrote:
> * Rafael J. Wysocki (rjw@sisk.pl) wrote:
> > Hi Mathieu,
> > 
> > As reported at
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=13903
> > 
> > one of my test systems suffers from a hibernation regression where the second
> > attempt to hibernate in a row makes it hang solid right before creating the
> > image.
> > 
> > Bisection turned up your commit 3f4a782b5ce2698b1870b5a7b573cd721d4fce33
> > ([CPUFREQ] fix (utter) cpufreq_add_dev mess) as the first bad one.
> > 
> 
> Can you try with the following patch applied ?
>
> http://www.spinics.net/lists/cpufreq/msg00964.html
>
> Subject: [PATCH 1/5] CPUFREQ: Fix a kobject reference bug related to managed CPUs
> From: Thomas Renninger <trenn@suse.de>

Tested (/me hates mailing list archives where you can't download raw messages
or at least raw patches) and it works.
 
Thanks a lot,
Rafael
