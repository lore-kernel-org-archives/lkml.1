Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbZCJMTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbZCJMTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 08:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbZCJMSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 08:18:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:8203 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbZCJMSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 08:18:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oJI0qQKj5uzwX271Lb3q5AGnyeZdtVhVgeHZKBQeo+DAnS4wcMVcLVlcE+i0w1na6F
         2MnLAw4VbLy1b4IwNjREVM84tCnGJYXK0GoK6uS5sHEmHid7Kagj5BllaNxg0fdwdWC7
         MSBbehMb93CUfC+SsUnVd1TXsWmeK3DqBz3yY=
MIME-Version: 1.0
In-Reply-To: <20090310121125.GC5794@elte.hu>
References: <20090309175330.CF63.A69D9226@jp.fujitsu.com>
	 <20090309092817.GA2184@elte.hu>
	 <20090310090828.A46F.A69D9226@jp.fujitsu.com>
	 <20090310121125.GC5794@elte.hu>
Date: Tue, 10 Mar 2009 21:18:48 +0900
X-Google-Sender-Auth: fec362622b5bc5ac
Message-ID: <2f11576a0903100518i640a5cefgb359cc3ab81688db@mail.gmail.com>
Subject: Re: [PATCH] ftrace: Don't use tracing_record_cmdline() in workqueue 
	tracer
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Doh!
>> My last mail's cc list didn't include lkml. that's unintensional silly
>> my mistake. very sorry.
>>
>> and Yes, memcpy(buf, task->comm, 16) mean two movq
>> instruction. that is worthless for caching. I think we can
>> remove this cache completely.
>
> ok, agreed - mind sending a patch for that?

ok, I'll do that.

>> and, I find my last patch has one race window. fixing below.
>
> Could you please send a delta patch against tip:master? Thanks,

maybe, I can send it tommorow.

thanks.
