Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZDPFr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZDPFr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZDPFrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:47:16 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:34877 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbZDPFrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:47:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JpkEFnqDSVsnxekw1lpLqroqcoftyqMc/9hskx6cV+MOlANRd2M+rdgV4TAKBTfTJ3
         lrl8Dd/2NwWRaTRP6rJOaseERo6vc3xMHZjVAbg7pgLxdrzKLIsj3Q+WY/kZJK8P0yF7
         cT8/XIWoABMbexkPPrBGD8U7BjTBydbw4wuTM=
Message-ID: <49E6C640.6060309@devnull.org>
Date: Thu, 16 Apr 2009 07:46:40 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
Newsgroups: linux.kernel
To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, hpa@zytor.com, tglx@linutronix.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
References: <crh66-6nQ-7@gated-at.bofh.it> <crilu-8hM-13@gated-at.bofh.it> <crjhu-1lb-13@gated-at.bofh.it> <crkQl-3QL-7@gated-at.bofh.it> <crm5K-5NR-17@gated-at.bofh.it> <crmyK-6DP-9@gated-at.bofh.it> <crnXV-g5-27@gated-at.bofh.it> <croh9-VK-5@gated-at.bofh.it> <croTQ-1Jm-1@gated-at.bofh.it> <crqVM-4UC-11@gated-at.bofh.it>
In-Reply-To: <crqVM-4UC-11@gated-at.bofh.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2009 06:00 AM, Theodore Tso wrote:
> On Thu, Apr 16, 2009 at 03:46:42AM +0200, Ingo Molnar wrote:
>> For similar reasons people have memos, stick-it's and other formal, 
>> automated, reflex-alike daily routine measures to make sure they 
>> dont forget to do something they all too easily forget otherwise.
> ...
>> This kind of formal measure _forces_ the extraction of this very 
>> specific type of summary on all sides of the contribution chain - 
>> and it drastically reduced the number of commits i regretted in 
>> hindsight.
> 
> 
> The question is whether Impact: _works_ in its current form.  I was
> came across a recent set of commits sent to you where it was
> pathetically obvious that Impact: doesn't really help.  
> 
> The patch submitter in question was a non-English speaker.  I've
> blacked out the submitter's name, because I'm not trying to call out
> that particular person, but rather the assumption that Impact: is
> always helpful.  Here's a very clear case where it is not.
> 
> I do feel your pain; there are one or two ext4 contributors where I
> always have to rewrite their commit logs and comments, and often I end
> up staring at the code trying to figure out what the !@#@? they meant.
> I used to try to coach them to make better messages, but I've since
> given up and just resigned myself to the fact that it's up to me
> rewrite the commit logs (and often, the comments in the code, too...)
> 
> If we are going to use the Impact: header, there should only be a few
> standardized values that it can have, i.e., "clean up", "fix oops",
> "fix lock ordering", "fix performance problem", etc.  Otherwise people
> will just put garbage in the Impact field --- what the heck does
> "Impact: it is not ready yet.  remove it" mean?  
> 
> Or "Impact: fix smp_affinity when moving irq_desc"?  
> 
> Or worse yet, "Impact: so use dev_to_node"?!?

Sorry if I'm speaking out of turn, would it not be more meaningful to
have "Tags:" or a "Keywords:" instead of a subjective impact assessment?

As for"Impact" - does the author at time of creation really know all the
possible problem permutations a specific piece of code might cause or
apply to?

Tags could however be helpful to someone that is not the developer or
maintainer.

As a real life example from an issue I just had, I would be inclined to
google for "brightness cannot be controlled by keyboard" rather than
gleaning anything from "i915: Register ACPI video even when not
modesetting" - even though that probably is a really clear commit
message in context of being the developer / maintainer.

It is not quite the same as "Impact", since someone else with XYZ laptop
might have some other issue as a result of the same commit.

The developer already has at least an entire paragraph to describe the
technicalities for his direct audience, but what about making the
problem context easier to understand (searchable) for the interested
outsiders? :)

cheers
Niel
