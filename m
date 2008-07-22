Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbYGVPYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbYGVPYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 11:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYGVPY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 11:24:26 -0400
Received: from saeurebad.de ([85.214.36.134]:51048 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbYGVPYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 11:24:25 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: rename PTE_MASK to PTE_PFN_MASK
References: <200807221431.58991.rusty@rustcorp.com.au>
	<488566EA.5040805@goop.org> <200807221540.47161.rusty@rustcorp.com.au>
	<4885774E.3000909@goop.org> <873am2kr4n.fsf@saeurebad.de>
	<4885F43B.7060307@goop.org> <8763qyj6br.fsf@saeurebad.de>
Date: Tue, 22 Jul 2008 17:23:59 +0200
In-Reply-To: <8763qyj6br.fsf@saeurebad.de> (Johannes Weiner's message of "Tue,
	22 Jul 2008 17:18:16 +0200")
Message-ID: <87wsjehrhs.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@saeurebad.de> writes:

> Hi,
>
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
>> Johannes Weiner wrote:
>>> PTE_PFN_MASK is not symmetric to PAGE_MASK.
>>
>> No, it isn't.  Is there anything about the name that suggests that it
>> should be?  PTE_PFN_MASK is for operating on pteval_t-typed values
>> extracted from ptes; PAGE_MASK is for operating on addresses.
>
> I meant the naming scheme, not the functionality.
>
> The thing PAGE_MASK and PTE_MASK have in common is that they are masks
> and their names indicate what is masked away when applied.
>
> So PAGE_MASK suggests that it masks out page details.  And PTE_MASK
> suggests that it masks out PTE details.
>
> PTE_PFN_MASK masks suggests that it masks out the flags, according to
> the existing naming convention.  But it does the opposite.

As you explained me how PAGE_MASK was meant, scratch the above ;)

	Hannes
