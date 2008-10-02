Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbYJBMST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbYJBMST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 08:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYJBMSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 08:18:11 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:20051 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbYJBMSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 08:18:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Jk0wyc7QVZx6JZZcRdED68bFL+fwJFTWTEIRcitF1gLML6J+a4QMNLrun+AFYPW3WY
         1e3gLNzEVJ3RRf+h8BLwfDDVcjZtsNLcWRQxdS4r4EJqd3Bn0EP1knDLfLFo2l8xF4Ff
         1dyS/8Z9MV/ZDRjhdrVQgPcWFDgKf4AfSAQDo=
Message-ID: <c62985530810020518t23879bd6r2426e68c867ecb64@mail.gmail.com>
Date: Thu, 2 Oct 2008 14:18:08 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH -tip 2/2] Tracing/fastboot: Get the initcall name before it disappears
Cc: "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20081002120231.GB14322@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48E4AFCD.9080004@gmail.com> <20081002120231.GB14322@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/2 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> After some initcall traces, some initcall names may be inconsistent.
>> That's because these functions will disappear from the .init section
>> and also their name from the symbols table.
>> So we have to copy the name of the function in a buffer large enough
>> during the trace appending. It is not costly for the ring_buffer because
>> the number of initcall entries is commonly not really large.
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>
> applied to tip/tracing/fastboot, thanks Frederic,
>
>        Ingo
>

BTW I forgot to cc Arjan.
Arjan if you have some time to test it, I would be interested by your
feeling about it since
the boot tracer has now an output which is parsable by bootgraph.pl.

Thanks!
