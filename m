Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbZBDRGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbZBDRGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 12:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZBDRGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 12:06:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57840 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbZBDRGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 12:06:31 -0500
Date: Wed, 4 Feb 2009 18:06:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Subject: Re: [PATCH 0 of 7] x86/paravirt: optimise pvop calls and register
	use
Message-ID: <20090204170612.GA4396@elte.hu>
References: <patchbomb.1233182100@abulafia.goop.org> <49815764.6040809@kernel.org> <49817C26.2020503@goop.org> <4983DBC9.5080701@kernel.org> <20090131161240.GA3014@elte.hu> <20090204021023.GA30736@elte.hu> <4988FA82.3030905@goop.org> <20090204142648.GF4411@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204142648.GF4411@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Ingo Molnar wrote:
> >> x86/paravirt is causing boot trouble on a 32-bit box - it reboots 
> >> during early bootup (it's a laptop so no easy access to its crashlog - 
> >> if there's any).
> >>
> >> config attached.
> >
> > HPA just applied a patch which will likely fix this.   
> > 0eb592dbba40baebec9cdde3ff4574185de6cbcc
> 
> thanks! Will need about 24 hours until i know for sure - the test-box that 
> is affected by this bug triggers the problem every 10 hours or so.

okay - a testbox just happened to trigger this PARAVIRT=y boot crash bug and 
i can confirm that latest tip/master fixes it.

	Ingo
