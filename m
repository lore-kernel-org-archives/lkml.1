Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbYFBXyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbYFBXyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 19:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYFBXyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 19:54:24 -0400
Received: from gw.goop.org ([64.81.55.164]:58669 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbYFBXyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 19:54:23 -0400
Message-ID: <48448807.7020601@goop.org>
Date: Tue, 03 Jun 2008 00:53:43 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Zachary Amsden <zach@vmware.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm: fix comment formatting in asm-generic/pgtable.h:__ptep_modify_prot_
References: <patchbomb.1212192268@localhost> <20080602111339.GB18586@elte.hu> <4843EF6A.20305@goop.org> <200806030946.00434.rusty@rustcorp.com.au>
In-Reply-To: <200806030946.00434.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Monday 02 June 2008 23:02:34 Jeremy Fitzhardinge wrote:
>   
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> ---
>>  include/asm-generic/pgtable.h |   14 +++++++++-----
>>  1 file changed, 9 insertions(+), 5 deletions(-)
>>
>> ===================================================================
>> --- a/include/asm-generic/pgtable.h
>> +++ b/include/asm-generic/pgtable.h
>> @@ -201,9 +201,11 @@
>>  					     unsigned long addr,
>>  					     pte_t *ptep)
>>  {
>> -	/* Get the current pte state, but zero it out to make it
>> -	   non-present, preventing the hardware from asynchronously
>> -	   updating it. */
>> +	/*
>> +	 * Get the current pte state, but zero it out to make it
>> +	 * non-present, preventing the hardware from asynchronously
>> +	 * updating it.
>> +	 */
>>     
>
> Since there is debate over whether winged comments are a feature, I'm not sure 
> this can be termed a "fix".
>   

I don't feel all that strongly about it in this case.  I'm not a huge 
fan of winged style for inline comments like this, but it is consistent 
with the rest of the file, and the comment is (just) long enough to make 
it not look completely stupid.

>>  {
>> -	/* The pte is non-present, so there's no hardware state to
>> -	   preserve. */
>> +	/*
>> +	 * The pte is non-present, so there's no hardware state to
>> +	 * preserve.
>> +	 */
>>  	set_pte_at(mm, addr, ptep, pte);
>>  }
>>     
>
> This will fit in one line, no? 
>   

Yes, but changing it would mean going to the effort of regenerating the 
patch.

    J
