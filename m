Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbYKSQRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbYKSQRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 11:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYKSQRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 11:17:06 -0500
Received: from gv-out-0910.google.com ([216.239.58.185]:21276 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbYKSQRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 11:17:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TaWU/Sx2IH3fDTXo9gvrOfcx6qw9k9zw4ycYy6DP2acZNICsYPWw5i6aIwJG8EvM17
         WtlyrGcmgb+MtIscgwUcsQLqHBcbjVcf2T0TkXACkvfYOS6/NIwgS50Yuz6o+k2c4Ydc
         s1zZTYcpgva7io51diPT1CLAcxktAtXPnFqMM=
Message-ID: <91b13c310811190817s31522a0et744ca7df2782cf27@mail.gmail.com>
Date: Thu, 20 Nov 2008 00:17:02 +0800
From: "rae l" <crquan@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH] kobject_add: use constant strings directly as fmt strings
Cc: "Jens Axboe" <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20081119155736.GA5072@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227110059-12529-1-git-send-email-crquan@gmail.com>
	 <20081119155736.GA5072@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 11:57 PM, Greg KH <gregkh@suse.de> wrote:
>>       ret = kobject_add(&q->kobj, kobject_get(&disk_to_dev(disk)->kobj),
>> -                       "%s", "queue");
>> +                       "queue");
>
> Why?  What does this change buy us?

Dropping one parameter makes the function call a little faster, doesn't it?

The results are the same,

so if the string is constant, why not use it directly as the fmt string?

Thanks.

>
> thanks,
>
> greg k-h

-- 
Cheng Renquan, Shenzhen, China
Lily Tomlin  - "The trouble with the rat race is that even if you win,
you're still a rat."
