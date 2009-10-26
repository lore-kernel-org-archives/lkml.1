Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbZJZSdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbZJZSdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbZJZSdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:33:31 -0400
Received: from relay3.sgi.com ([192.48.152.1]:34224 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751670AbZJZSdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:33:31 -0400
Message-ID: <4AE5EB80.7050201@sgi.com>
Date: Mon, 26 Oct 2009 11:33:36 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arjan van de Ven <arjan@infradead.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Andreas Mohr <andi@lisas.de>,
       Hugh Dickins <hugh@veritas.com>, Hannes Eder <hannes@hanneseder.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] SGI x86_64 UV: Limit the number of microcode	messages
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233756.941535000@alcatraz.americas.sgi.com> <b647ffbd0910241309u7b2f8c94t1f886ef31882539e@mail.gmail.com> <Pine.LNX.4.61.0910242207180.2439@ginsburg.homenet> <b647ffbd0910241545g4697a170peb00e541298d5a30@mail.gmail.com> <20091025163704.GE20391@elte.hu> <20091025101118.522a7aa4@infradead.org> <20091025172718.GA20060@elte.hu>
In-Reply-To: <20091025172718.GA20060@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Arjan van de Ven <arjan@infradead.org> wrote:
> 
>> On Sun, 25 Oct 2009 17:37:04 +0100
>> Ingo Molnar <mingo@elte.hu> wrote:
>>
>>> Having the precise microcode version printed (or exposed somewhere in 
>>> /sys) is useful - sometimes when there's a weird crash in some
>>> prototype CPU one of the first questions from hw vendors is 'which
>>> precise microcode version was that?'.
>> something like /sys/devices/system/cpu/cpu0/microcode/version ?
>>
>> (yes that is there today ;-)
> 
> yeah, i used that for a bug recently.
> 
> Nevertheless it makes sense to print the boot CPU message too - for bugs 
> that crash before we can read out 
> /sys/devices/system/cpu/cpu0/microcode/version.
> 
> 	Ingo

I added the printout of the first few cpus.  I had thought that maybe
printing the cpu info for each new socket discovered, perhaps reducing
that to each new blade or chassis as the number grew, but again it quickly
became more complex that I thought was necessary...(?)

If you get the first cpu started ok, then using a kernel debugger like
KDB, you can usually get the remaining information.

Thanks,
Mike
