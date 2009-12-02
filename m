Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbZLBOh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbZLBOh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZLBOh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:37:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbZLBOh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:37:27 -0500
Message-ID: <4B167B77.8030502@redhat.com>
Date: Wed, 02 Dec 2009 16:36:39 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: a.p.zijlstra@chello.nl, Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       torvalds@linux-foundation.org, mingo@redhat.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [tip:core/locking] locking, x86: Slightly shorten	 __ticket_spin_trylock()
References: <4B0FF9AC0200007800022713@vpn.id2.novell.com> <tip-133ec7a235160dd44cbd4d82fff65a9983331df9@git.kernel.org> <20091202132937.GA1564@elte.hu> <4B168293020000780002308E@vpn.id2.novell.com> <4B1675CA.1020504@redhat.com> <4B1686F702000078000230A6@vpn.id2.novell.com>
In-Reply-To: <4B1686F702000078000230A6@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2009 04:25 PM, Jan Beulich wrote:
>>>> Avi Kivity<avi@redhat.com>  02.12.09 15:12>>>
>>>>          
>> Wouldn't 'u8 ret', as an additional argument be sufficient? gcc still
>> ought to be able to use the same register for new and ret if we remove
>> the early clobber.
>>      
> We can't (validly) remove the early-clobber, otherwise the compiler
> would be permitted to use a register also used for addressing the lock
> structure for "new".
>    

I meant for 'ret'.

-- 
error compiling committee.c: too many arguments to function

