Return-Path: <linux-kernel-owner+w=401wt.eu-S1752656AbXBECGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbXBECGJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 21:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbXBECGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 21:06:09 -0500
Received: from [221.6.14.228] ([221.6.14.228]:33930 "EHLO proxy.fnst.com.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752656AbXBECGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 21:06:07 -0500
Message-ID: <00b201c748ca$3aa95cc0$2801a8c0@zhangxiliang>
From: "zhangxiliang" <zhangxiliang@nanjing-fnst.com>
To: "Matti Aarnio" <matti.aarnio@zmailer.org>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <026801c746a6$c3f81780$2801a8c0@zhangxiliang> <20070202091059.GB3438@mea-ext.zmailer.org>
Subject: Re: ntp
Date: Mon, 5 Feb 2007 10:06:19 +0800
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3028
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-RFC2646: Format=Flowed; Original
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
When I use the ntpd service, I see if I use the client attempt to connect 
the server repeat before the server is ready, the ntpd on server can not be 
ready all the times.

Sometimes the waiting time maybe very long.

----- Original Message ----- 
From: "Matti Aarnio" <matti.aarnio@zmailer.org>
To: "zhangxiliang" <zhangxiliang@nanjing-fnst.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Sent: Friday, February 02, 2007 5:10 PM
Subject: Re: ntp


> On Fri, Feb 02, 2007 at 04:47:26PM +0800, zhangxiliang wrote:
>> When i start the ntp service successful on server, the client must
>> ntpdate with the server after waiting a moment.
>> The moment may be 3~5 minutes, or it may be 10~15 minutes. I don't
>> know why it happens?
>
> The  ntp server  takes several external clock comparisons to know its
> local running environments (hosts) clock behaviour.
>
> Before it knows that, it has no real knowledge of what the time is,
> and it won't report anything out.
>
> In my environments I have couple local machines (usually doing
> something else too) assigned as network local NTP servers, and
> all other machines refer to them.
>
>
>> Regards
>> Zhang Xiliang
>> MAIL:zhangxiliang@nanjing-fnst.com
>
> /Matti Aarnio
> 



