Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbXH1KM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbXH1KM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 06:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbXH1KMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 06:12:18 -0400
Received: from nn7.de ([85.214.94.156]:46903 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbXH1KMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 06:12:17 -0400
Subject: Re: Linux 2.6.23-rc4
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0708271847560.25853@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0708271847560.25853@woody.linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Aug 2007 10:09:56 +0000
Message-Id: <1188295796.4594.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 18:58 -0700, Linus Torvalds wrote:
> Ok, I lost it, and let two weeks pass between -rc releases. My bad.
> 
> As a result, -rc4 is a bit bigger than it would/should have been, but 
> hopefully it's all good, and we've fixed most regressions. There's some 
> arch updates (MIPS, power, sparc64, s390) and an ACPI update, but the 
> rest of it is mainly lots of small fixes (mostly to various random 
> drivers). With some scheduler and networking noise.
> 
> I think the shortlog is _just_ too big to be posted on the kernel mailing 
> list, but since it can mostly be described with the one word "boring", 
> it's not a huge loss. As usual, just do
> 
> 	git shortlog v2.6.23-rc3..v2.6.23-rc4
> 
> if you have the git trees to get the all the details on extraneous 
> semicolons, missed or duplicate include files, kzalloc conversions, new 
> PCI ID's etc etc.

argh, something broke resume from s2ram on my mbp c1d... sometimes the
machine resumes when opening the lid and then pressing the power button,
but sometimes it is just dead (and it used to resume fine most of the
time when *only* opening the lid).

I hope I find time to do a bisect soon...

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
