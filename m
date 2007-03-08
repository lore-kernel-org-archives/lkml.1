Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbXCHBdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbXCHBdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 20:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbXCHBdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 20:33:52 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46022 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbXCHBdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 20:33:51 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Paul Menage" <menage@google.com>
Cc: "Sam Vilain" <sam@vilain.net>, "Srivatsa Vaddagiri" <vatsa@in.ibm.com>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xemul@sw.ru, dev@sw.ru, pj@sgi.com, winget@google.com,
       containers@lists.osdl.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
References: <20070301133543.GK15509@in.ibm.com>
	<20070307174346.GA19521@sergelap.austin.ibm.com>
	<20070307180055.GC17151@in.ibm.com>
	<20070307205846.GB7010@sergelap.austin.ibm.com>
	<6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
	<m1odn4bs6n.fsf@ebiederm.dsl.xmission.com>
	<6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>
	<45EF5A62.8000103@vilain.net>
	<6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>
	<45EF5E71.7090101@vilain.net>
	<6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com>
Date: Wed, 07 Mar 2007 18:32:10 -0700
In-Reply-To: <6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com>
	(Paul Menage's message of "Wed, 7 Mar 2007 16:58:43 -0800")
Message-ID: <m1d53ka5b9.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul Menage" <menage@google.com> writes:

> On 3/7/07, Sam Vilain <sam@vilain.net> wrote:
>> But "namespace" has well-established historical semantics too - a way
>> of changing the mappings of local * to global objects. This
>> accurately describes things liek resource controllers, cpusets, resource
>> monitoring, etc.
>
> Sorry, I think this statement is wrong, by the generally established
> meaning of the term namespace in computer science.
>
>>
>> Trying to extend the well-known term namespace to refer to things that
>> are semantically equivalent namespaces is a useful approach, IMHO.
>>
>
> Yes, that would be true. But the kinds of groupings that we're talking
> about are supersets of namespaces, not semantically equivalent to
> them. To use Eric's "shoe" analogy from earlier, it's like insisting
> that we use the term "sneaker" to refer to all footware, including ski
> boots and birkenstocks ...

Pretty much.  For most of the other cases I think we are safe referring
to them as resource controls or resource limits.    I know that roughly covers
what cpusets and beancounters and ckrm currently do.

The real trick is that I believe these groupings are designed to be something
you can setup on login and then not be able to switch out of.  Which means
we can't use sessions and process groups as the grouping entities as those 
have different semantics.

Eric
