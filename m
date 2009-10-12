Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbZJLN7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbZJLN7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932154AbZJLN7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:59:54 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:33431 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbZJLN7x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:59:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OqK9iccPZ4novzLgtk3R0EQjBvDjadN7IzHD4Av+HEaSN7WEFrTX8z8MdpJTudPc3Q
         cod7491YmfUA8x4RHsf7OOQ5v91DZBXRKDl+GvNx+/s8ZXHoug3WXp4UYuHL5yhUKGPk
         MOVntJ8euvd/sKqBiSJxTwySgRKy27Iy+Yc8Y=
MIME-Version: 1.0
In-Reply-To: <1255355219.7113.16.camel@gandalf.stny.rr.com>
References: <4AD2DEB9.2@redhat.com>
	 <c62985530910120209t3d263d5eh5aeba14fcecc9072@mail.gmail.com>
	 <1255355219.7113.16.camel@gandalf.stny.rr.com>
Date: Mon, 12 Oct 2009 15:59:15 +0200
Message-ID: <c62985530910120659s4b1f3cbfq2f6adccb16cf2c23@mail.gmail.com>
Subject: Re: [PATCH] ftrace: add kernel command line graph function filtering
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: rostedt@goodmis.org
Cc: Stefan Assmann <sassmann@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 12 octobre 2009 15:46, Steven Rostedt <rostedt@goodmis.org> a écrit :
> On Mon, 2009-10-12 at 11:09 +0200, Frédéric Weisbecker wrote:
>> 2009/10/12 Stefan Assmann <sassmann@redhat.com>:
>> > From 894e934e782ddaa33eb6d156d8326cdf479b5f62 Mon Sep 17 00:00:00 2001
>> > From: Stefan Assmann <sassmann@redhat.com>
>> > Date: Mon, 12 Oct 2009 09:11:47 +0200
>> > Subject: [PATCH] ftrace: add kernel command line graph function filtering
>> >
>> > Add a command line parameter to allow limiting the function graphs that
>> > are traced on boot up, when ftrace=function_graph is specified.
>> >
>> > This patch adds the following command line option:
>> > ftrace_graph_filter=function-list
>>
>>
>> If we use this parameter, we undoubtedly want to launch the function
>> graph tracer.
>> I'd then suggest to arm ftrace=function_graph automatically if we have
>> ftrace_graph_filter
>> set.
>>
>
> Actually, I disagree. I may just be lazy, and want to set up the
> function graph to a particular set of functions. It doesn't mean I want
> to run the function_graph tracer on boot up.
>
> This is the same reason I don't automatically set up ftrace=function
> when the filter and notrace functions are set.


No problem. I'll take the previous patch then, plus the kernel
parameter doc fix in the current one :-)
