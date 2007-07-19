Return-Path: <linux-kernel-owner+w=401wt.eu-S933828AbXGSNR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933828AbXGSNR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbXGSNRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:17:19 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38255 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752961AbXGSNRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:17:18 -0400
Date: Thu, 19 Jul 2007 15:16:40 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Scott Preece <sepreece@gmail.com>
Cc: James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
       Christian Ehrhardt <lk@c--e.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
Message-ID: <20070719131640.GT3801@stusta.de>
References: <Line.LNX.4.64.0707141233490.26711@d.namei> <20070718183503.541026f8.akpm@linux-foundation.org> <20070719073948.GI18840@lisa.in-ulm.de> <20070719122424.GA5186@vino.hallyn.com> <Line.LNX.4.64.0707190832290.4303@d.namei> <7b69d1470707190556n78e52232y7dfea1fd6f47ced@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7b69d1470707190556n78e52232y7dfea1fd6f47ced@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 07:56:53AM -0500, Scott Preece wrote:
> On 7/19/07, James Morris <jmorris@namei.org> wrote:
>> On Thu, 19 Jul 2007, Serge E. Hallyn wrote:
>>
>> > If we could get a few (non-afilliated :) people who work with
>> > customers in the security field to tell us whether this is being
>> > used, that would be very helpful.  Not sure how to get that.
>>
>> The mainline kernel does not cater to out of tree code.
>
> Please distinguish between "cater to" and "support". If the kernel
> didn't worry about supporting out-of-tree code, then why would there
> be loadable module at all?
>...

Distribution kernels need modules or the kernel images would be 
extremely large.

> Another twist is to use a tool to generate the module from a
> policy-definition file; this could be done at boot-time or could be
> done to replace the current policy on a running system (perhaps to add
> a new domain corresponding to a newly added service). Yes, this would
> need to be done with a lot of care, but part of providing mechanism
> (rather than policy) is enabling people to use the mechanism in the
> ways they prefer.

Why do you need to generate a module for changing a policy?

Software like SELinux contains the mechanisms to change the policy 
without having to change the kernel.

> scott

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

