Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbZBRHZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbZBRHZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 02:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbZBRHZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 02:25:39 -0500
Received: from smtp1.tech.numericable.fr ([82.216.111.37]:60673 "EHLO
	smtp1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbZBRHZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 02:25:39 -0500
Message-ID: <499BB7F0.7070709@numericable.fr>
Date: Wed, 18 Feb 2009 08:25:36 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Paul Moore <paul.moore@hp.com>
CC: Casey Schaufler <casey@schaufler-ca.com>,
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
> 
> If you do this you can simplify some of the code in smack_host_label() by 
> removing the code which applies the mask to the stored addresses when 
> comparing addresses.  There may be other places as well.
> 
you're right, in mk_write_netlbladdr also, i'll have a look
thanks,
Etienne
