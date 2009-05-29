Return-Path: <linux-kernel-owner+w=401wt.eu-S1761831AbZE2TyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761831AbZE2TyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 15:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbZE2TyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 15:54:13 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:58424 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbZE2TyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 15:54:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gInsIThEwTAV7RCZCPOj+5hOcflF471FhDxoI7mbjTlg8Wla1DDwxrOIxExh2YnmiQ
         OmC1lJsqasWg2BRFEoYKa4YfFlcvkOZJWVkn732yHuroekq6CeTpgfgBmOzJTG+s5b6n
         Gle9ey+xadUPRHJYd+RkRhhVf31Xr9QiW1aC8=
MIME-Version: 1.0
In-Reply-To: <200905292147.05395.rjw@sisk.pl>
References: <1243625720.4426.0.camel@plop> <200905292147.05395.rjw@sisk.pl>
Date: Fri, 29 May 2009 21:54:13 +0200
X-Google-Sender-Auth: 9a65ca54fa164a4b
Message-ID: <e8ca35370905291254o759dc18x8a6b318228c8ba4e@mail.gmail.com>
Subject: Re: Stable regression 2.6.29.3 vs 2.6.29.2
From: Pascal Terjan <pterjan@mandriva.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, stable <stable@kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/29 Rafael J. Wysocki <rjw@sisk.pl>:
> On Friday 29 May 2009, Pascal Terjan wrote:
>> (Resending because of wrong To:, sorry for the duplicate)
>>
>> We have a machine here where hard disk is no longer detected at boot
>> time with 2.6.29.3 (it happens only on kernels with HIGHMEM4G + PAE and
>> not on the same one with HIGHMEM64G).
>>
>> Motherboard is ECS PF22 Extreme
>>
>> bisect blames this commit:
>>
>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=commit;h=3b442bfc78d351343fa539c63afde75d7b134316
>
> Would it be possible to check if the current mainline works correctly?
>

I'll do that on Tuesday (the machine is in the office)
