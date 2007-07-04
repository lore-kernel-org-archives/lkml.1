Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbXGDQad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbXGDQad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 12:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbXGDQa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 12:30:26 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:44956
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753556AbXGDQa0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 12:30:26 -0400
Message-Id: <468BE77E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 04 Jul 2007 17:31:26 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: Re: [PATCH] x86: make SMP locks handling interact properly
	with	CONFIG_DEBUG_RODATA (2nd try)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On x86-64 additionally remove all mappings past the kernel image, and
>>> remove leftovers from the removal of the more general (but abandoned)
>>> SMP alternatives.
>>>   
>>
>>I'd already posted a patch to remove smp alternatives.  I thought it had 
>>been merged already, but I guess it's in Andi's queue.
>
>Oh, sorry, I forgot to remove that part of the comment after merging up to
>2.6..22-rcX.

Actually, no, the comment is right - it talks about pieces left in x86-64's
vmlinux.lds.S.

Jan

