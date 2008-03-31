Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbYCaNIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbYCaNIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 09:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbYCaNH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 09:07:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47308 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387AbYCaNH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 09:07:57 -0400
Date: Mon, 31 Mar 2008 15:07:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, yhlu.kernel@gmail.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] x86_64: V2 Support for new UV apic
Message-ID: <20080331130739.GE14636@elte.hu>
References: <20080328191216.GA16455@sgi.com> <20080331020207.GA20605@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331020207.GA20605@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> Fix double-shift of apicid in previous patch.

> The code is clearly wrong.  I booted on an 8p AMD box and had no 
> problems. Apparently the kernel (at least basic booting) is not too 
> sensitive to incorrect apicids being returned. Most critical-to-boot 
> code must use apicids from the ACPI tables.

yeah - patch added. Thanks Yinghai for persisting on this.

	Ingo
