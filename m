Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbZHTQGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbZHTQGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 12:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZHTQGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 12:06:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58790 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbZHTQGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 12:06:45 -0400
Message-ID: <4A8D7321.3090104@zytor.com>
Date: Thu, 20 Aug 2009 09:00:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT PULL] Fix Xen boot with CONFIG_CC_STACKPROTECTOR
References: <4A8C98DD.2020709@goop.org> <20090820100644.GC29093@elte.hu>
In-Reply-To: <20090820100644.GC29093@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2009 03:06 AM, Ingo Molnar wrote:
> 
> Pulled into tip:x86/urgent, thanks a lot Jeremy!
> 
> Btw., is there any way to turn off stackprotector on a 
> per function basis, a GCC attribute perhaps? That would 
> be preferable to turning it off for all of common.o.
> 

Jeremy asked me that, I researched it, and there isn't one -- the only
option is to segregate functions into separate files.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

