Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbZBRGBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbZBRGBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 01:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZBRGBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 01:01:12 -0500
Received: from smtp102.prem.mail.sp1.yahoo.com ([98.136.44.57]:22564 "HELO
	smtp102.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750984AbZBRGBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 01:01:11 -0500
X-YMail-OSG: TSEEIIMVM1m0YNTwebbmdaKPBb7ezUCyC0f0d8WRB7nZb6bQncs9YerYqOgtxevfYtEIABCM1bniR8azNSvbgk0ZGfAVZolJuPjl6FEC5QBuNZ8DQqt_Y3AIuYXV3CpbjIzf94Ba.ivB2BODeIp1cJmyLSLzeVRw_bjAh54AS_pNEQQ.6zvffd7UBxw1Tq25A5f80wM19omJ1DWvGHXswm3dkkLhlr6oSa4zazGtjDQ.VfLHCdAGvQs_hQc-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <499BA422.4090502@schaufler-ca.com>
Date: Tue, 17 Feb 2009 22:01:06 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Paul Moore <paul.moore@hp.com>
CC: etienne <etienne.basset@numericable.fr>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] SMACK smacklabel : apply &MASK to IP inserted in /smack/netlabel
References: <fa.O38YY4pVfLlMFJNBI3mhgn+qOcQ@ifi.uio.no> <499B178B.9090601@numericable.fr> <499B1ECF.2020809@numericable.fr> <200902171854.17203.paul.moore@hp.com>
In-Reply-To: <200902171854.17203.paul.moore@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Moore wrote:
> On Tuesday 17 February 2009 03:32:15 pm etienne wrote:
>   
>> ----
>> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
>> index 8e42800..5717150 100644
>> --- a/security/smack/smackfs.c
>> +++ b/security/smack/smackfs.c
>> @@ -765,6 +765,7 @@ static ssize_t smk_write_netlbladdr(struct file *file,
>> const char __user *buf, mask.s_addr |= bebits;
>>                 bebits <<= 1;
>>         }
>> +       newname.sin_addr.s_addr &= mask.s_addr;
>>         /*
>>          * Only allow one writer at a time. Writes should be
>>          * quite rare and small in any case.
>>     
>
> If you do this you can simplify some of the code in smack_host_label() by 
> removing the code which applies the mask to the stored addresses when 
> comparing addresses.  There may be other places as well.
>
>   
1234567890123456789012345678901234567890123456789012345678901234567890

Thank all of you for your kind suggestions. I'm in the process
of cleaning up after a meltdown in the Smack test lab, but I will
look into this as soon as I can. Did I ever say how much I dislike
netmasks?


