Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbYGVNER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbYGVNER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbYGVNEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:04:05 -0400
Received: from saeurebad.de ([85.214.36.134]:49896 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbYGVNEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:04:04 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: rename PTE_MASK to PTE_PFN_MASK
References: <200807221431.58991.rusty@rustcorp.com.au>
	<488566EA.5040805@goop.org> <200807221540.47161.rusty@rustcorp.com.au>
	<4885774E.3000909@goop.org>
Date: Tue, 22 Jul 2008 15:03:36 +0200
In-Reply-To: <4885774E.3000909@goop.org> (Jeremy Fitzhardinge's message of
	"Mon, 21 Jul 2008 22:59:42 -0700")
Message-ID: <873am2kr4n.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Rusty, in his peevish way, complained that macros defining constants
> should have a name which somewhat accurately reflects the actual
> purpose of the constant.
>
> Aside from the fact that PTE_MASK gives no clue as to what's actually
> being masked, and is misleadingly similar to the functionally entirely
> different PMD_MASK, PUD_MASK and PGD_MASK, I don't really see what the
> problem is.

PTE_PFN_MASK is not symmetric to PAGE_MASK.  How about PTE_PROT_MASK?

	Hannes
