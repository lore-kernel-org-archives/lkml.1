Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbXLDVhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbXLDVhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbXLDVgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:36:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33845 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbXLDVgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:36:49 -0500
Date: Tue, 4 Dec 2007 22:36:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] Unify mmap_[32|64].c
Message-ID: <20071204213636.GB11216@elte.hu>
References: <1196801553.10408.24.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196801553.10408.24.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> x86: Unify mmap_32.c mmap_64.c
> 
> Start from mmap_32.c and add X86_64 specific function as well.

the principle looks good to me. A small detail: please send standard 
format patches, the following rename:

>  arch/x86/mm/{mmap_32.c => mmap.c} |   57 ++++++++++++++++++++-----------------

is a git extension and quilt does not know it.

	Ingo
