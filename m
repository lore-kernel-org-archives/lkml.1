Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbXGDQ3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbXGDQ3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 12:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbXGDQ24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 12:28:56 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:44880
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753550AbXGDQ24 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 12:28:56 -0400
Message-Id: <468BE722.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 04 Jul 2007 17:29:54 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: Re: [PATCH] x86: make SMP locks handling interact properly
	with	CONFIG_DEBUG_RODATA (2nd try)
References: <468B5B54.76E4.0078.0@novell.com> <468BBFB3.9080303@goop.org>
In-Reply-To: <468BBFB3.9080303@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 04.07.07 17:41 >>>
>Jan Beulich wrote:
>> Instead of suppressing the change of .text to become readonly, make
>> the SMP locks patching code properly adjust/restore the page access
>> rights.
>>   
>
>I guess we'll need to do the same thing for paravirt_ops patching?

No, the patch already does this (as long as there no code to do that other
than in alternatives.c).

>> On x86-64 additionally remove all mappings past the kernel image, and
>> remove leftovers from the removal of the more general (but abandoned)
>> SMP alternatives.
>>   
>
>I'd already posted a patch to remove smp alternatives.  I thought it had 
>been merged already, but I guess it's in Andi's queue.

Oh, sorry, I forgot to remove that part of the comment after merging up to
2.6..22-rcX.

Jan

