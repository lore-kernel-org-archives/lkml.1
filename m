Return-Path: <linux-kernel-owner+w=401wt.eu-S1762813AbXESLyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762813AbXESLyn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 07:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757892AbXESLyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 07:54:37 -0400
Received: from mx1.suse.de ([195.135.220.2]:40746 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757846AbXESLyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 07:54:36 -0400
From: Andi Kleen <ak@suse.de>
To: Christian Volkmann <haveaniceday@cv-sv.de>
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64 II
Date: Sat, 19 May 2007 13:54:06 +0200
User-Agent: KMail/1.9.1
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
References: <464B9D2C.7040704@cv-sv.de> <200705190753.16570.ak@suse.de> <464EE2AA.3030607@cv-sv.de>
In-Reply-To: <464EE2AA.3030607@cv-sv.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705191354.06763.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 May 2007 13:42, Christian Volkmann wrote:
> Andi Kleen wrote:
> > Can someone please test if this patch works?
> >
> > This preserves the 6 <= model  <= 9 logic of the C code; this means
> > if VIA ever brings out model >= 10 it hopefully sets this bit by default.
> > Dave, do you have any information to the contrary?
> >
> > -Andi
>
> Hi Andi,
>
> your patch did not work. See the correction below. The mask should contain
> 1<<1 instead of 1.
> Model 10 is now also included.

Ok thanks fixed.

> I add also a patch for setup.S. It does not print the CPUID message in case
> the CPUID is wrong, cause %ds was not set proper.

I have this already as a separate patch with your name.

-Andi
