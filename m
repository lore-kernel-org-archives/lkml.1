Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbYGMBzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbYGMBzl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 21:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbYGMBze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 21:55:34 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62807 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752839AbYGMBzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 21:55:33 -0400
Date: Sun, 13 Jul 2008 02:54:53 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too
In-Reply-To: <86802c440807121845u3a51b239h95fa46cfb6f7c770@mail.gmail.com>
Message-ID: <Pine.LNX.4.55.0807130246560.4128@cliff.in.clinika.pl>
References: <200807080141.05436.yhlu.kernel@gmail.com> 
 <200807092017.51004.yhlu.kernel@gmail.com>  <200807102038.26591.yhlu.kernel@gmail.com>
  <200807111841.55403.yhlu.kernel@gmail.com>  <Pine.LNX.4.55.0807130241390.4128@cliff.in.clinika.pl>
 <86802c440807121845u3a51b239h95fa46cfb6f7c770@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jul 2008, Yinghai Lu wrote:

> >  Etc...  Why are you changing names of these functions?  Are they meant
> > not to apply to older APIC implementations anymore?
> 
> because 64bit has that name.

 Shouldn't it be the other way round then?  Our 32-bit code is the
original one and supports more APIC variations than the 64-bit one.  So at
the point of unification 64-bit xAPIC-only functions will become universal
ones making the naming counter-intuitive: apic_ -> any APIC, xapic_ ->
xAPIC only.  I think only functions specific to the xAPIC should have the
xapic_ prefix.

  Maciej
