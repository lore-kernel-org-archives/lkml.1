Return-Path: <linux-kernel-owner+w=401wt.eu-S1751980AbXA2Tg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbXA2Tg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbXA2Tg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:36:29 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52770 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbXA2Tg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:36:29 -0500
Date: Mon, 29 Jan 2007 11:36:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Auke Kok <auke-jan.h.kok@intel.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: Possible regression: MSI vector leakage since 2.6.18-rc5ish
 (Unable to repeatedly allocate/free MSI interrupt)
In-Reply-To: <45BE443B.3080407@intel.com>
Message-ID: <Pine.LNX.4.64.0701291135080.3611@woody.linux-foundation.org>
References: <45BA82DA.6050201@intel.com> <m1bqkku8bp.fsf@ebiederm.dsl.xmission.com>
 <45BE443B.3080407@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Jan 2007, Auke Kok wrote:
> 
> Yes. A few hundred cycles of loading/unloading snd_hda_intel with enable_msi=1
> didn't break it on i386.
> 
> I sure hope this can get into 2.6.20!

Eric, can you write an explanation, add your sign-off, Auke's ACK, and 
send out the result? The patch looked ok to me, but I do want the more 
deeper explanation too (and sign-off, of course).

		Linus
