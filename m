Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbZAKNzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbZAKNzK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 08:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbZAKNy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:54:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45894 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbZAKNyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:54:55 -0500
Date: Sun, 11 Jan 2009 14:54:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Petr Titera <P.Titera@century.cz>
Cc: linux-kernel@vger.kernel.org,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: Linux 2.6.29-rc1
Message-ID: <20090111135443.GA20288@elte.hu>
References: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain> <4969E4D7.5050802@century.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4969E4D7.5050802@century.cz>
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


* Petr Titera <P.Titera@century.cz> wrote:

> Unfortunatelly it cannot be built without SMP support. This patch seems 
> to fix it:

Note, this build bug needs the !SMP + ACPI=y + X86_LOCAL_APIC=y 
combination of configs to trigger. It wont trigger on normal UP nor on any 
SMP config.

	Ingo
