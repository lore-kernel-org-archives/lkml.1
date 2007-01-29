Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbXA2ToB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbXA2ToB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbXA2ToB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:44:01 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54539 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbXA2ToA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:44:00 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Auke Kok <auke-jan.h.kok@intel.com>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: Possible regression: MSI vector leakage since 2.6.18-rc5ish (Unable to repeatedly allocate/free MSI interrupt)
References: <45BA82DA.6050201@intel.com>
	<m1bqkku8bp.fsf@ebiederm.dsl.xmission.com>
	<45BE443B.3080407@intel.com>
	<Pine.LNX.4.64.0701291135080.3611@woody.linux-foundation.org>
Date: Mon, 29 Jan 2007 12:42:47 -0700
In-Reply-To: <Pine.LNX.4.64.0701291135080.3611@woody.linux-foundation.org>
	(Linus Torvalds's message of "Mon, 29 Jan 2007 11:36:22 -0800 (PST)")
Message-ID: <m1zm81ipqg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, 29 Jan 2007, Auke Kok wrote:
>> 
>> Yes. A few hundred cycles of loading/unloading snd_hda_intel with enable_msi=1
>> didn't break it on i386.
>> 
>> I sure hope this can get into 2.6.20!
>
> Eric, can you write an explanation, add your sign-off, Auke's ACK, and 
> send out the result? The patch looked ok to me, but I do want the more 
> deeper explanation too (and sign-off, of course).

Sure.  Give me a couple of minutes.

Eric
