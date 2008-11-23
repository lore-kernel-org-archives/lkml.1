Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYKWSZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYKWSZF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 13:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbYKWSYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 13:24:55 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:26900 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYKWSYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 13:24:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZKpWkjPK8WYrTKqJ5Mshhgphj5fL94Zrg6RIKX/A7Ti88TYpQ3IMYozW5cStA8s100
         xSp2lnUS18xasCgOmDmBZnUw2CKYAKIHG/mnO/w/sYE8hWQwDdDryRdaKkrFWIVmQcpL
         uVKvCqdLpnVecronpaOHNajL47vFdtrFNS1wU=
Message-ID: <b637ec0b0811231024t73d1b8b3x9e23e24dda94c6b8@mail.gmail.com>
Date: Sun, 23 Nov 2008 19:24:53 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200811231914.09982.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b637ec0b0811230817x5b445a0m665305d2b6bf6c1f@mail.gmail.com>
	 <200811231914.09982.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>>
>> This problem:
>>
>> * never happened in 2.6.27.4
>> * happened many times in 2.6.27.5 and .6
>> * never happened in 2.6.27.7
>
> Please test 2.6.27.7 a bit more.  It would be helpful to verify it's OK.
>

Just reproduced the problem with 2.6.27.7. It behaved differently: the
system hung for about 4 minutes and then revived. No logs
unfortunately.

>> * happened the first time with the current -rc series just now (the
>> logs are related to this one)
>>
>> This is the first 2.6.28-rc kernel I tried.
>
> Do you mean 2.6.28-rc6?
>

Yes. I started another bisection session between 2.6.27.4 and 2.6.27.5.

> Rafael

Regards,
Fabio


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
