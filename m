Return-Path: <linux-kernel-owner+w=401wt.eu-S934167AbXGQRs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934167AbXGQRs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758639AbXGQRst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:48:49 -0400
Received: from ns1.suse.de ([195.135.220.2]:58190 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758920AbXGQRss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:48:48 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Reading the VDSO area - i386
Date: Tue, 17 Jul 2007 19:48:41 +0200
User-Agent: KMail/1.9.6
Cc: john.blackwood@ccur.com, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Roland McGrath <roland@redhat.com>, bugsy@ccur.com,
       Andrew Morton <akpm@linux-foundation.org>
References: <469CECFE.6060408@ccur.com> <469CF2BC.3000306@goop.org>
In-Reply-To: <469CF2BC.3000306@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707171948.42054.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2007 18:47:56 Jeremy Fitzhardinge wrote:
> John Blackwood wrote:
> > I was doing some tests that attempt to read the VDSO area of a
> > task through either the /proc/pid/mem or ptrace(PTRACE_PEEKTEXT,
> > ...) interfaces, and it seems that when the CONFIG_COMPAT_VDSO kernel
> > parameter is enabled, we can no longer successfully read the VDSO area
> > on i386 kernels.
> 
> Thanks.  Someone else noticed this recently, and posted a near-identical
> patch.  But I can't seem to find it right now...
> 
> Andrew, Andi: do you remember something like this passing by?

Yes it was from Jan Beulich.

-Andi
