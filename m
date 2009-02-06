Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbZBFOxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbZBFOxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbZBFOxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:53:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56285 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbZBFOxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:53:38 -0500
Date: Fri, 6 Feb 2009 15:53:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: akataria@vmware.com, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Zach Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Rohit Jain <rjain@vmware.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PARAVIRT/x86] BUGFIX: Put a missing paravirt_release_pmd in
	pgd_dtor
Message-ID: <20090206145324.GF18368@elte.hu>
References: <1233885731.29693.26.camel@alok-dev1> <498BA0CA.2040603@goop.org> <1233901043.8943.6.camel@alok-dev1> <498BDE1D.8030101@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498BDE1D.8030101@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Alok Kataria wrote:
>> As it affects only VMI, instead of adding another callback, i have
>> hooked on the paravirt_pgd_free call for vmi to release the pgd page.
>> Below is the patch. I will run some overnight tests with this patch and
>> get back if there are any errors.
>>   
>
> I'd forgotten that I'd already added pgd_alloc/pgd_free.  So, yes, just  
> use pgd_free.

Can i take that as an Acked-by?

	Ingo
