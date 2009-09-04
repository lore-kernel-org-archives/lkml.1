Return-Path: <linux-kernel-owner+w=401wt.eu-S933298AbZIDQzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbZIDQzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932751AbZIDQzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:55:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60407 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706AbZIDQzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:55:19 -0400
Message-ID: <4AA145E6.8000603@zytor.com>
Date: Fri, 04 Sep 2009 09:52:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Tejun Heo <tj@kernel.org>, mingo@redhat.com, linux-kernel@vger.kernel.org,
       jeremy.fitzhardinge@citrix.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86/i386: Make sure stack-protector segment base
 is cache aligned
References: <4AA01893.6000507@goop.org> <tip-1ea0d14e480c245683927eecc03a70faf06e80c8@git.kernel.org> <4AA02687.9080406@zytor.com> <4AA02B02.7080101@goop.org> <4AA031DE.2070109@zytor.com> <4AA080A0.7010804@kernel.org> <4AA08283.5020306@kernel.org> <4AA08B09.50503@zytor.com> <4AA139DF.3050902@goop.org>
In-Reply-To: <4AA139DF.3050902@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2009 09:01 AM, Jeremy Fitzhardinge wrote:
>>>     
>> It's correct that it doesn't make any difference for access, only for load.
>>   
> 
> Well, to be completely precise, restore.  When returning to usermode,
> the "pop %seg" is slightly faster if you're restoring a null selector,
> which is typically the case for %fs as 32-bit usermode doesn't use it.
> 

That's a segment load...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

