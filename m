Return-Path: <linux-kernel-owner+w=401wt.eu-S1759015AbYCFATx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbYCFATx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 19:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYCFATo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 19:19:44 -0500
Received: from hiauly1.hia.nrc.ca ([132.246.100.193]:1385 "EHLO
	hiauly1.hia.nrc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbYCFATn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 19:19:43 -0500
Subject: Re: [PATCH -mm 0/3] fix iommu segment boundary problems (parisc)
To: grundler@parisc-linux.org (Grant Grundler)
Date: Wed, 5 Mar 2008 19:19:31 -0500 (EST)
From: "John David Anglin" <dave@hiauly1.hia.nrc.ca>
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, tomof@acm.org, kyle@parisc-linux.org,
       matthew@wil.cx, grundler@parisc-linux.org, akpm@linux-foundation.org
In-Reply-To: <20080305154502.GA32538@colo.lackof.org> from "Grant Grundler" at Mar 5, 2008 08:45:02 am
X-Mailer: ELM [version 2.4 PL25]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20080306001933.248744E43@hiauly1.hia.nrc.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And thanks to Joel Soete (rubisher) for testing. I tried to test the
> sba_iommu code on my local box but had issues with the unpatched kernel
> (using kyle's parisc-2.6.git tree) that I have yet to resolve (could be
> HW problems).

I built two kernels today using kyle's parisc-2.6.git tree (UP 32 bit
and SMP 64 bit).  Aside from some section mismatch warnings, they both
seem to work fine.

Dave
-- 
J. David Anglin                                  dave.anglin@nrc-cnrc.gc.ca
National Research Council of Canada              (613) 990-0752 (FAX: 952-6602)
