Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZAaQNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZAaQNO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 11:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbZAaQM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 11:12:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49380 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbZAaQM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 11:12:57 -0500
Date: Sat, 31 Jan 2009 17:12:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Subject: Re: [PATCH 0 of 7] x86/paravirt: optimise pvop calls and register
	use
Message-ID: <20090131161240.GA3014@elte.hu>
References: <patchbomb.1233182100@abulafia.goop.org> <49815764.6040809@kernel.org> <49817C26.2020503@goop.org> <4983DBC9.5080701@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4983DBC9.5080701@kernel.org>
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


* H. Peter Anvin <hpa@kernel.org> wrote:

> Jeremy Fitzhardinge wrote:
> > H. Peter Anvin wrote:
> >> The failing configuration was x86-64 "make allyesconfig".
> >>
> >>     -hpa
> >>   
> > Subject: x86/paravirt: fix missing callee-save call on pud_val
> > 
> > Fix missed convertion to using callee-saved calls for pud_val, which
> > causes a compile error when CONFIG_PARAVIRT_DEBUG is enabled.
> > 
> 
> Series applied to tip:x86/paravirt; it should make its way into
> tip:master and linux-next over the next day or two, unless there are
> failures.

there's some build trouble on VMI:

arch/x86/kernel/vmi_32.c: In function ‘activate_vmi’:
arch/x86/kernel/vmi_32.c:673: error: incompatible types in assignment
arch/x86/kernel/vmi_32.c:673: error: incompatible types in assignment
arch/x86/kernel/vmi_32.c:674: error: incompatible types in assignment
arch/x86/kernel/vmi_32.c:674: error: incompatible types in assignment
arch/x86/kernel/vmi_32.c:675: error: incompatible types in assignment
arch/x86/kernel/vmi_32.c:675: error: incompatible types in assignment
arch/x86/kernel/vmi_32.c:676: error: incompatible types in assignment
arch/x86/kernel/vmi_32.c:676: error: incompatible types in assignment

	Ingo
