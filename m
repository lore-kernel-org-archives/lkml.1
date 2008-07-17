Return-Path: <linux-kernel-owner+w=401wt.eu-S1759031AbYGQHTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031AbYGQHTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbYGQHT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:19:28 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:19618 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbYGQHT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:19:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YcHRJc2yRX64UE8f5VKENdsVN7yuaJHR8CCi6lzk8Ev/PNwmBwmwR8WwRnahfDSjm/
         nEN8Ilyvm/oATVDjS/+G7eDnY7utZY304HbtMDGm4nYFTRhmJT4d53Q4QmnEDLj2nYUH
         zUCozoeVwaKiqw7aIyoekf9Gsz2jnDFMmM+9s=
Message-ID: <487EF279.2050704@gmail.com>
Date: Thu, 17 Jul 2008 04:19:21 -0300
From: "Rafael C. de Almeida" <almeidaraf@gmail.com>
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: pageexec@freemail.hu
CC: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
References: <20080703185727.GA12617@suse.de>, <487D2371.10258.1BDBBC00@pageexec.freemail.hu>, <alpine.LFD.1.10.0807151331110.2867@woody.linux-foundation.org> <487D3056.1183.1C0E1C47@pageexec.freemail.hu>
In-Reply-To: <487D3056.1183.1C0E1C47@pageexec.freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pageexec@freemail.hu wrote:
> On 15 Jul 2008 at 13:42, Linus Torvalds wrote:
> 
>> On Tue, 15 Jul 2008, pageexec@freemail.hu wrote:
>>> i understand and i think noone expects that. in fact, i know how much
>>> expertise and time it takes to determine that. but what happens when
>>> you do figure out the security relevance of a bug during bug submission
>> The issue is that I think it's then _misleading_ to mark that kind of 
>> commit specially, when I actually believe that it's in the minority.
>>
>> If people think that they are safer for only applying (or upgrading to) 
>> certain patches that are marked as being security-specific, they are 
>> missing all the ones that weren't marked as such.
> 
> and how is that different from today's situation where they aren't told
> at all? in other words, they already learned to live with that risk. if
> you tell them about a security bug, they will build that knowledge into
> their risk assessment process (which is what security is all about in
> the end). anything you omit will skew their decision making process (in
> particular, expose them to exploits if they fail to apply a fix because
> they make a bad judgement call).
> 
> in other words, you should not be worrying about people not learning about
> all security fixes, they already know it's not possible to provide such
> information. however sharing your knowledge that you do have will *help*
> them because 1. they can know for sure it's something important to apply
> (no need to use their limited human resources to make that judgement),
> 2. they can spend more of their resources on analyzing the *other* unmarked
> fixes. overall this can only improve everyone's security.

Hey, I have a crazy idea! What if they just mark all the bugs as a
security bug (after all they all kinda are for some definition of
security anyway)? That way people just apply all the patches and do not
have to analyze anything, therefore not wasting their limited human
resources at all!

Linus' point is exactly that they shouldn't be treated differently, so
you shouldn't allocate human resources to other bugs and just apply the
security ones. If you want to convince someone you must tell us *why*
those so-called security bugs are more important. Also, you need to tell
us what you consider to be a security bug. That's not clear to me at least.

> what you're afraid of is that people will take your 'we mark security
> fixes we learn about' as 'we mark ALL security fixes that are such'. well,
> make that very clear in a public document (Documentation/SecurityBugs is
> a good place) and that's it, people will know you're doing a best effort
> disclosure and not more.
> 
> cheers,
>   PaX Team
