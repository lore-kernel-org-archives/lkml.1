Return-Path: <linux-kernel-owner+w=401wt.eu-S934999AbYD1OZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934999AbYD1OZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933675AbYD1OZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:25:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933761AbYD1OZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:25:39 -0400
Message-ID: <4815DC28.9050801@redhat.com>
Date: Mon, 28 Apr 2008 11:16:08 -0300
From: Glauber Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Sergio Luis <sergio@uece.br>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, ak@suse.de
Subject: Re: [PATCH] build fix for smp
References: <12059466674071-git-send-email-gcosta@redhat.com>	 <20080319195217.GA20762@elte.hu> <ce0170d90804280052y130c3fa2pbf3f97147f03b159@mail.gmail.com>
In-Reply-To: <ce0170d90804280052y130c3fa2pbf3f97147f03b159@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergio Luis wrote:
> On Wed, Mar 19, 2008 at 4:52 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>  * Glauber de Oliveira Costa <gcosta@redhat.com> wrote:
>>
>>  > +#if defined(CONFIG_X86_64) || defined(CONFIG_X86_BIOS_REBOOT)
>>  >       if (reboot_force)
>>  >               return;
>>  > +#endif
>>
>>  please solve it slightly differently: introduce a uniformly usable
>>  reboot_force flag, that will always default to the constant of 1 if
>>  !X86_64 && !X86_BIOS_REBOOT. That makes the code cleaner - and not the
>>  least i can also merge the fix earlier in the series, without having to
>>  redo the big smp.c movement patch :-)
>>
>>         Ingo
>>
> 
> Hello,
> what's the final fix for this issue? 2.6.25-git11 is still broken, just gave me
Doh. I had the patch, but completely forgot to send it to ingo. Thanks 
for raising this issue again. (But I saw ingo already put a fix for this in)

> arch/x86/kernel/built-in.o: In function `native_smp_send_stop':
> smp.c:(.text+0xc751): undefined reference to `reboot_force'
> make: *** [.tmp_vmlinux1] Error 1
> 
> for a randconfig. Same reported at http://lkml.org/lkml/2008/4/27/39
> 
> thanks,
> -sergio

