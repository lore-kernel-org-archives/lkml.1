Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbYAFJKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbYAFJKH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 04:10:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYAFJJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 04:09:50 -0500
Received: from il.qumranet.com ([82.166.9.18]:50949 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbYAFJJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 04:09:49 -0500
Message-ID: <47809ADC.2010403@qumranet.com>
Date: Sun, 06 Jan 2008 11:09:48 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 20/52] KVM: Add missing #include	<asm/pgtable.h>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>	<1198998638-22713-21-git-send-email-avi@qumranet.com> <20080103181448.GB7141@does.not.exist>
In-Reply-To: <20080103181448.GB7141@does.not.exist>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sun, Dec 30, 2007 at 09:10:06AM +0200, Avi Kivity wrote:
>   
>> Needed for empty_zero_page.
>>
>> Signed-off-by: Avi Kivity <avi@qumranet.com>
>> ---
>>  drivers/kvm/kvm_main.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
>> index 469e6b4..d6c5191 100644
>> --- a/drivers/kvm/kvm_main.c
>> +++ b/drivers/kvm/kvm_main.c
>> @@ -46,6 +46,7 @@
>>  #include <asm/io.h>
>>  #include <asm/uaccess.h>
>>  #include <asm/desc.h>
>> +#include <asm/pgtable.h>
>>  
>>  MODULE_AUTHOR("Qumranet");
>>  MODULE_LICENSE("GPL");
>>     
>
> Can you merge this patch into the previous one for the final submission?
>
> For being able to bisect (which has proven to be a very valuable help) 
> we aim at having the tree between any two commits both compiling and 
> working.
>   

Certainly, I'll do that.


-- 
error compiling committee.c: too many arguments to function

