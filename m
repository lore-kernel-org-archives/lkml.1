Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbYGZPoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbYGZPoQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 11:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYGZPoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 11:44:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58027 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbYGZPoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 11:44:00 -0400
Date: Sat, 26 Jul 2008 17:43:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, vegardno@ifi.uio.no,
       penberg@cs.helsinki.fi, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] kmemcheck: include module.h to prevent warnings
Message-ID: <20080726154346.GB15945@elte.hu>
References: <20080724160932.cdcf4927.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724160932.cdcf4927.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> kmemcheck/shadow.c needs to include <linux/module.h> to prevent
> the following warnings:
> 
> linux-next-20080724/arch/x86/mm/kmemcheck/shadow.c:64: warning : data definition has no type or storage class
> linux-next-20080724/arch/x86/mm/kmemcheck/shadow.c:64: warning : type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> linux-next-20080724/arch/x86/mm/kmemcheck/shadow.c:64: warning : parameter names (without types) in function declaration

applied to tip/kmemcheck - thanks Randy.

	Ingo
