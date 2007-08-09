Return-Path: <linux-kernel-owner+w=401wt.eu-S936957AbXHIHOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936957AbXHIHOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 03:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758869AbXHIHOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 03:14:35 -0400
Received: from gw.goop.org ([64.81.55.164]:49561 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbXHIHOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 03:14:34 -0400
Message-ID: <46BABE72.90107@goop.org>
Date: Thu, 09 Aug 2007 00:12:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <glommer@gmail.com>
CC: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 25/25] [PATCH] add paravirtualization support for x86_64
References: <11865467522495-git-send-email-gcosta@redhat.com>	 <11865468321629-git-send-email-gcosta@redhat.com>	 <11865468362401-git-send-email-gcosta@redhat.com>	 <11865468394005-git-send-email-gcosta@redhat.com>	 <11865468431616-git-send-email-gcosta@redhat.com>	 <1186546847263-git-send-email-gcosta@redhat.com>	 <11865468513077-git-send-email-gcosta@redhat.com>	 <46BAB5C8.5090906@goop.org>	 <5d6222a80708090002y7fdc6f2dw1dbacd3d27a86433@mail.gmail.com>	 <46BABC0F.5070002@goop.org> <5d6222a80708090007h3d185ecdm3ea8fa0b5ee96050@mail.gmail.com>
In-Reply-To: <5d6222a80708090007h3d185ecdm3ea8fa0b5ee96050@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> On 8/9/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>   
>>> Does it really matter?
>>>
>>>       
>> Well, yes, if alignment is an issue.
>>     
> Of course, But the question rises from the context that they are both
> together at the beginning. So they are not making anybody non-aligned.
> Then the question: Why would putting it in the end be different to
> putting them _together_, aligned at the beginning ?
>   

Well, the point is that if you add new ones then alignment may be an
issue.  Putting them at the end (with a comment explaining why they're
there) will make it more robust.  Though splitting them into their own
sub-structure would probably be better.

Hm.  So x86-64 doesn't make 64-bit pointers be 64-bit aligned?

    J
