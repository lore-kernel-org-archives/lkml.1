Return-Path: <linux-kernel-owner+w=401wt.eu-S966131AbXDGRVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966131AbXDGRVJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 13:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966143AbXDGRVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 13:21:09 -0400
Received: from gw.goop.org ([64.81.55.164]:54390 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966131AbXDGRVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 13:21:07 -0400
Message-ID: <4617D2D1.7040202@goop.org>
Date: Sat, 07 Apr 2007 10:20:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@suse.de>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/4] clean up identify_cpu
References: <20070406224152.556848893@goop.org>	<20070406224204.782242327@goop.org> <20070407021401.a993892b.akpm@linux-foundation.org>
In-Reply-To: <20070407021401.a993892b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> x86_64 uses this too.
>
> WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text:mtrr_bp_init from .text.identify_cpu after 'identify_cpu' (at offset 0x655)
>   

OK, two patches to follow: a x86-64 variant of the bugs.h cleanup, and a
replacement for this patch. I don't have a x86-64 compile environment on
hand, so the 64 bits are completely untested, but they *look* they
should work.

J
