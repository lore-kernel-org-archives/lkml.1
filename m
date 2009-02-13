Return-Path: <linux-kernel-owner+w=401wt.eu-S1758352AbZBMLsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352AbZBMLsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 06:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZBMLsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 06:48:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36996 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbZBMLsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 06:48:08 -0500
Date: Fri, 13 Feb 2009 12:47:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86: more header untangling
Message-ID: <20090213114755.GH15679@elte.hu>
References: <4991D626.5040009@goop.org> <20090211100323.GE20518@elte.hu> <49930485.3070204@goop.org> <20090211171439.GA9185@elte.hu> <49931F04.80605@goop.org> <20090211194719.GA25968@elte.hu> <49935287.3000504@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49935287.3000504@goop.org>
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

> Ingo Molnar wrote:
>> Another possibility would be to make a further distinction between 
>> 'local methods' and 'compound methods'. Local methods are the ones that 
>> only relate to a given
>> data type. Compound methods combine multiple types. We could allow 
>> local methods in type headers, and forbid compound methods.
>>   
>
> Yes, that's pretty much the approach I've been taking.  Particularly  
> since these little helper functions are smoothing over a given type  
> being defined in different ways in different environments (the types  
> themselves are different, but the types of the functions operating on  
> them are the same).

ok, cool, no disagreements then. Your point about the type being
standardized by the helpers is important, i missed that aspect.

	Ingo
