Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZLURWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZLURWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 12:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbZLURWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 12:22:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60364 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbZLURWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 12:22:11 -0500
Message-ID: <4B2FADC5.3020709@zytor.com>
Date: Mon, 21 Dec 2009 09:17:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Ritesh Raj Sarraf <rrs@researchut.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.33-rc1 build failure: copy_from_user() buffer size is not
 provably correct
References: <0io307-9ti.ln1@news.researchut.com> <20091221180537.089C.A69D9226@jp.fujitsu.com> <20091221091330.GA22867@elte.hu>
In-Reply-To: <20091221091330.GA22867@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2009 01:13 AM, Ingo Molnar wrote:
> 
> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
>>>                  from mm/migrate.c:15:
>>> In function ???copy_from_user???,
>>>     inlined from ???do_pages_stat??? at mm/migrate.c:1009:
>>> /tmp/all-yes-config/2.6.33-rc1/arch/x86/include/asm/uaccess_32.h:213: error: 
>>> call to ???copy_from_user_overflow??? declared with attribute error: 
>>> copy_from_user() buffer size is not provably correct
>>
>> afaik, ingo already queued this fix.
>> please wait (very) few days.
>>
>> thanks.
> 
> hm, the one mm/migrate.c fix we had is already in -rc1:
> 
>  b9255850: mm: Adjust do_pages_stat() so gcc can see copy_from_user() is safe
> 
> I've Cc:-ed more folks.
> 

That *is* the error report that he is describing.  What version of gcc
is he using?  It might be dumber than the one I have.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

