Return-Path: <linux-kernel-owner+w=401wt.eu-S933735AbZHEMQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735AbZHEMQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 08:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933697AbZHEMQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 08:16:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58245 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933696AbZHEMQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 08:16:31 -0400
Date: Wed, 5 Aug 2009 14:16:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gleb Natapov <gleb@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, sheng@linux.intel.com,
       avi@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86/apic: Enable x2APIC without interrupt
	remapping under KVM
Message-ID: <20090805121621.GA31918@elte.hu>
References: <20090720122417.GR5638@redhat.com> <tip-ee6a28296de295d62a3d8fad8bab58a8a48d006f@git.kernel.org> <20090804133715.GA29573@elte.hu> <20090804165702.GF4764@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804165702.GF4764@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0036]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gleb Natapov <gleb@redhat.com> wrote:

> +static inline void x2apic_force_phys()
> +{
> +}

Sigh. Have you tested this patche and have you looked at the 
resultig compiler output?

	Ingo
