Return-Path: <linux-kernel-owner+w=401wt.eu-S1760123AbYGNX7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123AbYGNX7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 19:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760032AbYGNX7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 19:59:20 -0400
Received: from sh.osrg.net ([192.16.179.4]:49354 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760037AbYGNX7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 19:59:19 -0400
Date: Tue, 15 Jul 2008 08:56:47 +0900
To: mingo@elte.hu
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       joerg.roedel@amd.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 16/34] AMD IOMMU: add kernel command line parameters
	for AMD IOMMU
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080710062603.GB23054@elte.hu>
References: <20080710132447T.fujita.tomonori@lab.ntt.co.jp>
	<20080709213907.1e8b253b.akpm@linux-foundation.org>
	<20080710062603.GB23054@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080715085310L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 08:26:03 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 10 Jul 2008 13:25:23 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > I have one related question, we should document all the kernel boot
> > > parameters in Documentation/kernel-parameters.txt?
> > > 
> > > Some of x86_64 boot parameters are in
> > > Documentations/x86/x86_64/boot-options.txt. The parameters of IOMMUs
> > > are scattered. It's confusing.
> > 
> > A single monolithic file has advantages.  I think I'd prefer that 
> > personally.  I'd forgotten that the x86-specific one exists, actually.
> 
> yeah, it should be all in Documentation/kernel-parameters.txt.

Then, let's integrate them right after rc1 (to avoid lot of conflicts
with patches that change Documentation/kernel-parameters.txt).
