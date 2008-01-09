Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbYAIJv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbYAIJv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 04:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYAIJvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 04:51:48 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:35215
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752216AbYAIJvr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 04:51:47 -0500
Message-Id: <4784A751.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 09 Jan 2008 09:52:01 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <hch@infradead.org>, <pagg@oss.sgi.com>, <erikj@sgi.com>, <pj@sgi.com>,
       <matthltc@us.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] add task handling notifier
References: <476A780C.76E4.0078.0@novell.com>
 <20071223122621.GA19310@infradead.org>
 <20071225140526.547a882f.akpm@linux-foundation.org>
 <47838ACB.76E4.0078.0@novell.com>
 <20080108141424.de5d8fba.akpm@linux-foundation.org>
In-Reply-To: <20080108141424.de5d8fba.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Am I to conclude then that there's no point in addressing the issues other
>> people pointed out? While I (obviously, since I submitted the patch disagree),
>> I'm not certain how others feel. My main point for disagreement here is (I'm
>> sorry to repeat this) that as long as certain code isn't allowed into the kernel
>> I think it is not unreasonable to at least expect the kernel to provide some
>> fundamental infrastructure that can be used for those (supposedly
>> unacceptable) bits. All I did here was utilizing the base infrastructure I want
>> added to clean up code that appeared pretty ad-hoc.
>> 
>
>Ah.  That's a brand new requirement.

I'm sorry, but I didn't feel this was important, as I didn't expect the cleanup
effect to cause much debate...

>I think we'd need a pretty detailed description of the pain which this
>would relieve before we would take such an extraordinary step.  What are
>those (unidentified) add-on features doing at present?  Patching calls into
>fork.c/exec.c/exit.c?

Yes. And the unidentified feature is NLKD. But as with other notifiers (most
notably the module unload one), all reasonable kernel debuggers should
need them (or do explicit patching of the mentioned source files). As I
explained before, I think that if kernel debuggers aren't allowed into the
tree, they should at least be allowed to co-exist (since the argument of
requiring in-tree users and submitting code for mainline inclusion is void
if political/personal reasons exclude certain code from even being
considered for inclusion).

Jan

