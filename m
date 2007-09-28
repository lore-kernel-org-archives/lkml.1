Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbXI1NiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbXI1NiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 09:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbXI1Nhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 09:37:55 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:5429 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbXI1Nhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 09:37:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=H+zGQ0rh1Uz7bZm/Uy68DHbspg6HNAOD0o0AVSWYmKcXvsbn37dmS1pTHQOEiEA22sS5QV/2rIUZ7RDtS3AH1HzT690UGkI9yJXEgds0dpIFB6vopTzRSlVzheSAxRbddZcayxknuenAQlHKzW4jeb75cMzdbTL0DDPPzk+3g8Y=
Message-ID: <84144f020709280637w2290aec5gf3e8f90b08f53cc8@mail.gmail.com>
Date: Fri, 28 Sep 2007 16:37:49 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: [PATCH] update checkpatch.pl to version 0.10
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Randy Dunlap" <rdunlap@xenotime.net>,
       "Joel Schopp" <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070928132138.GG18163@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bf97f66cfc0696c8574921d53eaafcb7@pinky>
	 <20070928084003.GA18882@elte.hu>
	 <20070928020132.f6c6f528.akpm@linux-foundation.org>
	 <20070928092235.GA31180@shadowen.org> <20070928093902.GA28455@elte.hu>
	 <20070928100024.GB18163@shadowen.org> <20070928104935.GA606@elte.hu>
	 <20070928132138.GG18163@shadowen.org>
X-Google-Sender-Auth: 6a50f39d4cd805fc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On 9/28/07, Andy Whitcroft <apw@shadowen.org> wrote:
> That is unfair.  Every time we discuss it I state that I disagree that
> hiding mostly useful tests is a good thing.  I would love the tests to
> be 100% accurate, but if I removed all the tests that can false positive
> I would literally have none.  There is a balance to be struck and we
> have significantly different ideas on where the balance is.

Are you disagreeing with the numbers Ingo posted? 25,000 false
positives for the kernel is beyond silly... Existing conventions
should matter a lot and the default configuration for a static code
checker should really be 100%. So why not hide the potentially useful
warnings under -Wtoo-strict or similar command line option?
