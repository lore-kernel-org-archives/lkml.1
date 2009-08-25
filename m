Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbZHYOfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbZHYOfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755135AbZHYOfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:35:44 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:51194 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbZHYOfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:35:43 -0400
Message-Id: <4A9412DE0200007800011A07@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 25 Aug 2009 15:35:42 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <tglx@linutronix.de>, <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
       <linux-tip-commits@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [tip:x86/urgent] x86: Fix build with older
	 binutilsandconsolidate linker script
References: <4A8AEA1F0200007800010563@vpn.id2.novell.com>
 <tip-ddc98b38b6320d5de2e3167673a06ec1a48e9d0e@git.kernel.org>
 <20090825075029.GA857@elte.hu>
 <4A9408FC02000078000119B1@vpn.id2.novell.com>
 <20090825135651.GA22484@elte.hu>
 <4A940AE502000078000119C5@vpn.id2.novell.com>
 <20090825141405.GA14879@elte.hu>
In-Reply-To: <20090825141405.GA14879@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 25.08.09 16:14 >>>
>
>* Jan Beulich <JBeulich@novell.com> wrote:
>
>> >>> Ingo Molnar <mingo@elte.hu> 25.08.09 15:56 >>>
>> >Would it be possible to split it into two pieces: 'minimal fix' and 
>> >'clean up' portions?
>> 
>> Besides being cumbersome, that would make it even larger, so I'd 
>> say that's not worth it.
>
>I mean the two patches yield the same end result. The first one 

I also understood it that way.

>(which is smaller, hopefully) gets committed to x86/urgent, the 
>second one (the cleanups and other non-essentials) gets pushed 
>upstream in .32.

The cleanup part really isn't much more than what I described with
"Once touching this code, also use the various data section helper
macros from include/asm-generic/vmlinux.lds.h.", and if the first
patch wouldn't use those macros, it would just grow and become
even less readable.

Jan

