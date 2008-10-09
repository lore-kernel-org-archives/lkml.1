Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbYJIObv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbYJIObv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 10:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbYJIObn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 10:31:43 -0400
Received: from smtpauth.net4india.com ([202.71.129.41]:40586 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbYJIObn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 10:31:43 -0400
Message-ID: <48EE1599.8090507@xenontk.org>
Date: Thu, 09 Oct 2008 20:00:49 +0530
From: David John <davidjon@xenontk.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, vojtech@suse.cz, bob.picco@hp.com,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] HPET: Remove the BKL.
References: <1223551371-3764-1-git-send-email-davidjon@xenontk.org> <871vypudp2.fsf@basil.nowhere.org>
In-Reply-To: <871vypudp2.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> David John <davidjon@xenontk.org> writes:
>> @@ -586,7 +583,7 @@ static const struct file_operations hpet_fops = {
>>  	.llseek = no_llseek,
>>  	.read = hpet_read,
>>  	.poll = hpet_poll,
>> -	.ioctl = hpet_ioctl,
>> +	.unlocked_ioctl = hpet_ioctl,
> 
> Did this actually compile without warning? unlocked_ioctl 
> has a different prototype than ioctl
> 
> -Andi
> 

Argg. I didn't check. :-[. Incidentally, this seems to have been done by 
Alan here: http://lkml.org/lkml/2008/5/22/350. Was the patch dropped later?

CC'd: Alan Cox

David.
