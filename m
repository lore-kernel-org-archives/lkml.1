Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbZKQLyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbZKQLyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbZKQLyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:54:47 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:36431 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbZKQLyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:54:46 -0500
Date: Tue, 17 Nov 2009 19:54:43 +0800
From: Franko Fang <huananhu@huawei.com>
Subject: Re: [PATCH 17/11]Optimize the upload speed for PPP connection.
To: Jarek Poplawski <jarkao2@gmail.com>,
       William Allen Simpson <william.allen.simpson@gmail.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <00b301ca677c$c03f25d0$76900b0a@china.huawei.com>
MIME-version: 1.0
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
X-Mailer: Microsoft Outlook Express 6.00.2900.3598
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
X-Priority: 3
X-MSMail-priority: Normal
References: <20091117111454.GA8341@ff.dom.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, yes, I think that it misses the tab.

I will update the patch, and resubmit it again.

 Thanks for all  .
----- Original Message ----- 
From: "Jarek Poplawski" <jarkao2@gmail.com>
To: "William Allen Simpson" <william.allen.simpson@gmail.com>
Cc: <huananhu@huawei.com>; "David Miller" <davem@davemloft.net>; <netdev@vger.kernel.org>; <linux-kernel@vger.kernel.org>
Sent: Tuesday, November 17, 2009 7:14 PM
Subject: Re: [PATCH 17/11]Optimize the upload speed for PPP connection.


> On 17-11-2009 11:20, William Allen Simpson wrote:
>> David Miller wrote:
>>> Your patch is broken, please don't wate my time like this.
>>>
>>> + git apply --check --whitespace=error-all diff
>>> error: patch failed: drivers/net/ppp_async.c:36
>>> error: drivers/net/ppp_async.c: patch does not apply
>>>
>> What David may have meant, had he followed Documentation/ManagementStyle
>> or had any project management skills what-so-ever, is that you need to
>> follow Documentation/SubmittingPatches more carefully.
> 
> I think this time it was only about a missing tab ;-)
> 
> Jarek P.
> 
>> 
>> Look at 15) The canonical patch format
>> 
>> [PATCH 17/11] makes no sense, you don't have 11 patches, and the 17th
>> patch of 11 can never exist.
>> 
>> Need a better "subsystem: summary phrase", perhaps
>>    "net: PPP buffer too small for higher speed connections"
>> 
>> A marker line containing simply "---".
>> 
>> And your trailer boilerplate badly breaks the system, because it's
>> missing the SMTP email standard "--" line in front of it.
>> 
>> You'll get nicer formatting with 'git format-patch -o ~ HEAD~1' after you
>> do a 'git commit -a' on your git tree.
>> 
>> It takes some time, even for a simple 1 line fix like this....
>> 
>> Hope that helps.
>> --
>> To unsubscribe from this list: send the line "unsubscribe netdev" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
