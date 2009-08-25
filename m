Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbZHYOBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbZHYOBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbZHYOBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:01:40 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:49800 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850AbZHYOBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:01:39 -0400
Message-Id: <4A940AE502000078000119C5@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 25 Aug 2009 15:01:41 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <tglx@linutronix.de>, <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
       <linux-tip-commits@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [tip:x86/urgent] x86: Fix build with older binutils
	 andconsolidate linker script
References: <4A8AEA1F0200007800010563@vpn.id2.novell.com>
 <tip-ddc98b38b6320d5de2e3167673a06ec1a48e9d0e@git.kernel.org>
 <20090825075029.GA857@elte.hu>
 <4A9408FC02000078000119B1@vpn.id2.novell.com>
 <20090825135651.GA22484@elte.hu>
In-Reply-To: <20090825135651.GA22484@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 25.08.09 15:56 >>>
>* Jan Beulich <JBeulich@novell.com> wrote:
>> Sorry for having forgotten to do so before submitting the first 
>> time (I know I had intended to).
>
>This happens. I'm still unsure whether we can do it in .31.0 or need 
>to delay it to .31.1 via a -stable backport tag. One more problem 
>with it and i think we'll need to delay it - it's just too large and 
>changes too many aspects of the linker script.
>
>Would it be possible to split it into two pieces: 'minimal fix' and 
>'clean up' portions?

Besides being cumbersome, that would make it even larger, so I'd say
that's not worth it.

Jan

