Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbZKKHvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbZKKHvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:51:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbZKKHvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:51:03 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.27]:58231 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbZKKHvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:51:02 -0500
Message-ID: <4AFA6CEB.6020202@ladisch.de>
Date: Wed, 11 Nov 2009 08:51:07 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Andreas Herrmann <herrmann.der.user@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86, ucode-amd: Load ucode-patches once and not separately
 fo each CPU
References: <20091110110601.GG30802@alberich.amd.com>	 <20091110110723.GH30802@alberich.amd.com> <b647ffbd0911100402k4f8648b8ref712f4c60fb8a7b@mail.gmail.com>
In-Reply-To: <b647ffbd0911100402k4f8648b8ref712f4c60fb8a7b@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> btw., if we could safely assume that all the cpus after the ucode
> upgrade share the same version/patch-level of ucode, we would be able
> to cache a single ucode instance once and use it for all. I don't
> recall anyone clearly stating that such multi-cpu-type systems can't
> really exist.
> 
> e.g. is it possible to have AMD systems with cpus which differ from
> each other not only by their revisions (patch_level)?

The Revision Guide for AMD Family 10h Processors (#41322) says, in
section "Mixed Silicon Support", that the Opteron B steppings can be
used with each other (DR-BA, DR-B2, DR-B3; CPUID 00100F2xh).  Are
different steppings considered equivalent?


Clemens
