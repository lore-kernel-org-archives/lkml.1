Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030773Ab0B0UGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 15:06:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45761 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030759Ab0B0UGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 15:06:46 -0500
Message-ID: <4B897A7D.9040108@zytor.com>
Date: Sat, 27 Feb 2010 12:03:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/cpu changes for v2.6.34
References: <20100227150942.GA6394@elte.hu> <20100227091039.7608155c@infradead.org>
In-Reply-To: <20100227091039.7608155c@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2010 09:10 AM, Arjan van de Ven wrote:
> On Sat, 27 Feb 2010 16:09:42 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
>> +int wbinvd_on_all_cpus(void)
>> +{
>> +	return on_each_cpu(__wbinvd, NULL, 1);
>> +}
> 
> does this make sense at all?
> 
> doesn't cache coherency on x86 already guarantee this?
> 

No, WBINVD (unlike CLFLUSH) is local to one CPU.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

