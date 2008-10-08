Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbYJHHZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbYJHHZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 03:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbYJHHZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 03:25:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:18384 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYJHHZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 03:25:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=kTaHPrTq6ja+GW6k0QDISBOSZPzXu07pozoPl1Ukzx7T8GpA2YoekfF/tOBPlo0+Gw
         b4vqlp4fMgblviS2CAI2Z77xPE0nWMLFyrT6uf6RoTOO0F/X0+6NuUBX1+BondbGfL5/
         rrvxyvweCEvn3m22YPIrdVyk7rO+0M2UNjLbw=
Message-ID: <84144f020810080025o348ae189vab83f1620b2e9560@mail.gmail.com>
Date: Wed, 8 Oct 2008 10:25:07 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] SLOB's krealloc() seems bust
Cc: "Matt Mackall" <mpm@selenic.com>, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linuxfoundation.org>
In-Reply-To: <1223448220.1378.13.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223387841.26330.36.camel@lappy.programming.kicks-ass.net>
	 <1223441190.13453.459.camel@calx>
	 <200810081554.33651.nickpiggin@yahoo.com.au>
	 <200810081611.30897.nickpiggin@yahoo.com.au>
	 <1223442947.13453.462.camel@calx>
	 <1223448220.1378.13.camel@lappy.programming.kicks-ass.net>
X-Google-Sender-Auth: 63028c0b120da959
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Wed, 2008-10-08 at 00:15 -0500, Matt Mackall wrote:
>> Damnit, how many ways can we get confused by these little details? I'll
>> spin a final version and run it against the test harness shortly.

On Wed, Oct 8, 2008 at 9:43 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> So I'll wait with testing for the next version?

AFAICT, this should be fine:

http://lkml.org/lkml/2008/10/7/436

You need to revert the patch Linus already committed before applying
that though.

                            Pekka
