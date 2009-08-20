Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZHTQYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZHTQYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 12:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbZHTQYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 12:24:34 -0400
Received: from claw.goop.org ([74.207.240.146]:43787 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbZHTQYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 12:24:33 -0400
Message-ID: <4A8D78C1.5070708@goop.org>
Date: Thu, 20 Aug 2009 09:24:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arjan van de Ven <arjan@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT PULL] Fix Xen boot with CONFIG_CC_STACKPROTECTOR
References: <4A8C98DD.2020709@goop.org> <20090820100644.GC29093@elte.hu>
In-Reply-To: <20090820100644.GC29093@elte.hu>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/09 03:06, Ingo Molnar wrote:
>> I only need to disable stackprotector for a
>> handful of functions, but unfortunately it looks like it can only be
>> disabled on a per-file basis.
> Pulled into tip:x86/urgent, thanks a lot Jeremy!
>
> Btw., is there any way to turn off stackprotector on a 
> per function basis, a GCC attribute perhaps? That would 
> be preferable to turning it off for all of common.o.


Yeah, its awkward.  But it looks like this patch is not sufficient, so
drop it for now.  I'll send a replacement shortly (though it doesn't
hurt to keep it; I can just generate a delta if that's better).

    J
