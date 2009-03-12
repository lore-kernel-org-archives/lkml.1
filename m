Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbZCLLvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbZCLLvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbZCLLvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:51:24 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:35469 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159AbZCLLvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:51:23 -0400
Message-Id: <49B9056F.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 11:51:59 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <jeremy.fitzhardinge@citrix.com>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: fix HYPERVISOR_update_descriptor()
References: <49B8F3D4.76E4.0078.0@novell.com>
 <20090312105426.GC30204@elte.hu> <49B8FF3E.76E4.0078.0@novell.com>
 <20090312113520.GA8353@elte.hu>
In-Reply-To: <20090312113520.GA8353@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 12.03.09 12:35 >>>
>* Jan Beulich <jbeulich@novell.com> wrote:
>> I'm confused: What point is there to add a textual description 
>> that matches the subject? [...]
>
>For example, under what circumstances did you trigger the bug, 
>how widely does it affect people, how did you test it. You are 
>sending patches very close to the 2.6.29 release, and your 
>commit log is non-existent.
>
>Yes, i can figure out what the patch does, but that is not the 
>point.
>
>The point is for you to be forthcoming with such information and 
>trying to be helpful to the maintenance process, by properly 
>describing changes, by describing how you found the bug, how you 
>tested the fix, how significant you find the fix, etc.
>
>I.e. try to emit the information you have about this _already_, 
>and generously so, instead of hiding it and forcing others to 
>recover it.

Hmm, I'm really just following what I see from many others. And I have
to admit that there are [tiny] patches that really don't need much
explanation (and I often find quite the inverse - huge patches that have
[almost] no description).

>>It might be a small work for me to recover it and 
>>put it into the changelog, but many of your past patches showed 
>>such a pattern and such overhead mounts up quickly.

I'm sorry for that - I simply wasn't aware I'm causing you to do extra
work. I usually try to be as verbose with patches as seems necessary
to me - after all I have no other way to judge ho much is too little or
too much.

>> [...] And where is the need for an impact line documented 
>> (clearly neither SubmitChecklist no SubmittingPatches have any 
>> occurrence of the word impact), i.e. what are the valid values 
>> to chose from?
>
>See:
>
>  http://lkml.org/lkml/2008/10/28/67 

Thanks. Would certainly be helpful to put into Documentation/ if this is
meant to be more than just a personal requirement of yours.

Jan

