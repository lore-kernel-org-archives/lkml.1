Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbYIPOLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbYIPOLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 10:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbYIPOLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 10:11:13 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:62758 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYIPOLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 10:11:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Quzs+Jjg5nSS8YeVOsbHEF/A5t3QwPpdTZw0TSRvZJqHnpurnflxelvVlHvwfj9TIP
         kO3lPhn1FxZMueQnQuSn3VZCaL8YsxnwJ0vSvkdji4Jl6GamFF1XXiEcFXcaR26ZaaJd
         kfKfRfY5p9bDgCqJLV19aelffvM0I/mIGcHSM=
Message-ID: <ab40e9c0809160711p4182d9e7n9b3ce965b3ce9f1f@mail.gmail.com>
Date: Tue, 16 Sep 2008 16:11:10 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: "Bernd Petrovitsch" <bernd@firmix.at>
Subject: Re: looking for a function
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1221573632.6103.83.camel@spike.firmix.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab40e9c0809160550q411507aeledae30a9f835d09d@mail.gmail.com>
	 <1221573632.6103.83.camel@spike.firmix.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bernd,

thanks for you reply.

yes, I know the thread migrates all the time, this is exactly what I
would like to observe. I would like to learn about the thread
migration of some specific scheduling algorithm. so ....

any idea about the function?

Best regards,

Yang

2008/9/16, Bernd Petrovitsch <bernd@firmix.at>:
> Hi!
>
> On Tue, 2008-09-16 at 14:50 +0200, Xu Yang wrote:
> > Hi guys,
> >
> > I am looking for a function that can show me the current thread is
> > running on which cpu.
>
> > e.g I am using pthread to write a multithreaded program, in each
> > thread I would like to insert such kind of function so that I can know
> > on which cpu this thread is running on.
>
> That doesn't make much sense as the same thread can run on a different
> CPU after each scheduling decision. And - as it is in userspace -
> scheduling can happen before any assembler op.
>
>        Bernd
> --
> Firmix Software GmbH                   http://www.firmix.at/
> mobil: +43 664 4416156                 fax: +43 1 7890849-55
>          Embedded Linux Development and Services
>
>
>
