Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbYCZEt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbYCZEt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 00:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYCZEtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 00:49:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50684 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbYCZEtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 00:49:20 -0400
Date: Wed, 26 Mar 2008 05:49:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, yhlu.kernel@gmail.com
Subject: Re: [PATCH 2/2] [PATCH] move apic declarations to mach_apic.h
Message-ID: <20080326044901.GA3121@elte.hu>
References: <20080325150630.GA13828@elte.hu> <1206462537-8427-1-git-send-email-gcosta@redhat.com> <1206462537-8427-2-git-send-email-gcosta@redhat.com> <1206462537-8427-3-git-send-email-gcosta@redhat.com> <20080325195818.GA12302@elte.hu> <47E96A29.4000503@redhat.com> <20080326044745.GA2918@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326044745.GA2918@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> there's another build error i found:
> 
>  arch/x86/kernel/setup.c: In function 'setup_per_cpu_areas':
>  arch/x86/kernel/setup.c:87: error: expected ',' or ';' before '__attribute__'
> 
> config attached. This is with and without your second patch. (i.e. 
> independent problem, introduced by the 1/2 patch)

sorry - this is not your build bug :-)

	Ingo
