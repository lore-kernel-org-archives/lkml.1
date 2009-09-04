Return-Path: <linux-kernel-owner+w=401wt.eu-S933734AbZIDQ5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734AbZIDQ5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932871AbZIDQ53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:57:29 -0400
Received: from claw.goop.org ([74.207.240.146]:50961 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932452AbZIDQ52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:57:28 -0400
Message-ID: <4AA146FA.2000303@goop.org>
Date: Fri, 04 Sep 2009 09:57:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Tejun Heo <tj@kernel.org>, mingo@redhat.com, linux-kernel@vger.kernel.org,
       jeremy.fitzhardinge@citrix.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86/i386: Make sure stack-protector segment base
 is cache aligned
References: <4AA01893.6000507@goop.org> <tip-1ea0d14e480c245683927eecc03a70faf06e80c8@git.kernel.org> <4AA02687.9080406@zytor.com> <4AA02B02.7080101@goop.org> <4AA031DE.2070109@zytor.com> <4AA080A0.7010804@kernel.org> <4AA08283.5020306@kernel.org> <4AA08B09.50503@zytor.com> <4AA139DF.3050902@goop.org> <4AA145E6.8000603@zytor.com>
In-Reply-To: <4AA145E6.8000603@zytor.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/09 09:52, H. Peter Anvin wrote:
> On 09/04/2009 09:01 AM, Jeremy Fitzhardinge wrote:
>   
>>>>     
>>>>         
>>> It's correct that it doesn't make any difference for access, only for load.
>>>   
>>>       
>> Well, to be completely precise, restore.  When returning to usermode,
>> the "pop %seg" is slightly faster if you're restoring a null selector,
>> which is typically the case for %fs as 32-bit usermode doesn't use it.
>>
>>     
> That's a segment load...

Yeah, OK.

    J

