Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbZLaAP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbZLaAP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 19:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbZLaAP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 19:15:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48312 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbZLaAP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 19:15:26 -0500
Message-ID: <4B3BED7A.6020507@gmail.com>
Date: Thu, 31 Dec 2009 01:16:58 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       rientjes@google.com, cl@linux-foundation.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
       rusty@rustcorp.com.au, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/1] Constify struct kset_uevent_ops for 2.6.33-rc2
References: <cover.1260663000.git.re.emese@gmail.com> <eff97be7c5839477c88f7ba61ef100f38c58bf7d.1260663000.git.re.emese@gmail.com> <84144f020912250331h23b8b724v73cf70c384d385ec@mail.gmail.com> <4B355AEF.3060508@gmail.com> <4B39AEB2.5040809@cs.helsinki.fi> <4B3A6D63.4070700@gmail.com> <20091230001131.GA19830@suse.de>
In-Reply-To: <20091230001131.GA19830@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Dec 29, 2009 at 09:58:11PM +0100, Emese Revfy wrote:
>>>> I double checked both the declaration and definitions of the affected
>>>> function/structure and they are consistently const here.
>>>> Can you tell me what patch/tree combination you encountered this
>>>> warning with?
>>> 2.6.33-rc2 with your patch.
>> Here is the updated patch for 2.6.33-rc2 in one piece.
>> Emese
>>
>>
>> From: Emese Revfy <re.emese@gmail.com>
>>
>> Constify struct kset_uevent_ops.
> 
> Why is this needed?  What does it accomplish?

This is my contribution to the ops structure constification effort
that some developers started a few years ago (Arjan, Al Viro, etc.)
and that has been worked on somewhat sporadically ever since. For a
summary of why this is useful please see Arjan's email:
http://lkml.org/lkml/2009/12/14/216
--
Emese


