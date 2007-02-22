Return-Path: <linux-kernel-owner+w=401wt.eu-S1751500AbXBVIm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbXBVIm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbXBVIm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:42:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56696 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbXBVIm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:42:27 -0500
Date: Thu, 22 Feb 2007 09:37:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -freg-struct-return?
Message-ID: <20070222083716.GA15068@elte.hu>
References: <45DCF1C5.4030006@goop.org> <1172131463.3531.226.camel@laptopd505.fenrus.org> <45DD4FA0.5030205@goop.org> <1172132103.3531.228.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172132103.3531.228.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> > Do we have much assembler which cares about the struct return 
> > calling convention?  If not, it should be a fairly easy test.
> 
> is there an attribute to turn it off? because if so we should just 
> make that part of "asmlinkage".... (not that I know much code using 
> structs in asm)

i dont know of any such code - asmlinkage is 'long' or pointer based.

	Ingo
