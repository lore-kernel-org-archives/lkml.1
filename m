Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbZGaVnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbZGaVnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbZGaVnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:43:08 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:54744 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbZGaVnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:43:07 -0400
From: Nicolas Palix <npalix@diku.dk>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Fix compilation error in amd.c when SMP is not set
Date: Fri, 31 Jul 2009 23:36:44 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; i686; ; )
Cc: x86@kernel.org, Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
References: <200907311640.25585.npalix@diku.dk> <4A7325E5.7040102@zytor.com>
In-Reply-To: <4A7325E5.7040102@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907312336.44778.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 July 2009 19:12:05 H. Peter Anvin wrote:
> On 07/31/2009 07:40 AM, Nicolas Palix wrote:
> > The function amd_fixup_dcm requires SMP to be set
> > but it is called only when CONFIG_X86_HT is set.
> > 
> > It thus defined only if CONFIG_X86_HT is set.
> > 
> > Signed-off-by: Nicolas Palix <npalix@diku.dk>
> 
> I'm confused... I don't see this function anywhere in my trees, nor do I
> see git revision e06fa7c that this was based on either in my trees or
> the stable trees.  What is the base rev of this patch?
> 
> 	-hpa
> 

It's in next, commit 29160dfe027e90532bd60a97db1dd158d996be8b.

It's broken since the 30 as also reported by
http://kisskb.ellerman.id.au/kisskb/target/629/


-- 
Nicolas Palix
