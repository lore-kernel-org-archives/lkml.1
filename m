Return-Path: <linux-kernel-owner+w=401wt.eu-S1757625AbZBMS53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbZBMS53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 13:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbZBMS5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:57:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44640 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbZBMS5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:57:21 -0500
Date: Fri, 13 Feb 2009 19:57:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 headers: protect page_32.h via __ASSEMBLY__
Message-ID: <20090213185712.GB2186@elte.hu>
References: <49935DD8.8010705@goop.org> <20090213120239.GL15679@elte.hu> <20090213121858.GB5483@elte.hu> <20090213122325.GA30061@elte.hu> <20090213122724.GA2172@elte.hu> <20090213123721.GA1879@elte.hu> <4995BF9F.2050509@goop.org> <20090213184926.GA32338@elte.hu> <4995C182.5040009@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4995C182.5040009@goop.org>
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
>> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>
>>   
>>> Ingo Molnar wrote:
>>>     
>>>> From beb6943d8df7ce9278282101af4e0f6f7b648451 Mon Sep 17 00:00:00 2001
>>>> From: Ingo Molnar <mingo@elte.hu>
>>>> Date: Fri, 13 Feb 2009 13:36:47 +0100
>>>> Subject: [PATCH] x86 headers: protect page_32.h via __ASSEMBLY__
>>>>         
>>> I think this is wrong in principle.  There should never be a reason 
>>> to  include a non-_types.h into asm.
>>>
>>> (Fine as a build fix, of course.)
>>>     
>>
>> Agreed - but it needs fixes to the .S files, these assembly files
>> include pgtable.h or page.h:
>>   
>
> Piecemeal, or one sweep?

i think the change itself should be in one commit, it's rather trivial.

	Ingo
