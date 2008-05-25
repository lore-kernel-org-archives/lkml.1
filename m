Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbYEYDiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbYEYDiK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 23:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbYEYDh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 23:37:57 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:27304 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbYEYDh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 23:37:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UcSzA1Y4dHuAFR0yWYJSkUo1OLL28uC+hNvX7oBn7zz0ehSBqUjM6AlnTEwKPJQz3qkz2TtKt+QHsiYVQPEg49qW2vtEmfcPl8cXnIBZ/prVEk4BDVkKpk3kHhbAubXCrSdn2wA7LciiiQD4nyESE61FLDbd97Zh0x5vE25isU0=
Message-ID: <ee101c360805242037y333b3e17n705ef9b1572125c9@mail.gmail.com>
Date: Sun, 25 May 2008 11:37:54 +0800
From: "Shuduo Sang" <sangshuduo@gmail.com>
To: devzero@web.de
Subject: Re: Inserting code from userspace to kernel space
Cc: bosko.radivojevic@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <289344083@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <289344083@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m4P3cnHl019992

On Fri, May 23, 2008 at 10:30 PM,  <devzero@web.de> wrote:>>> I know this sounds quite weird, but maybe there is a project that can help us ;)>>>>>>>actually you can implement a parser/interpretor, whatever you name it,>>in kernel space. And you can send the>>function code from user space to kernel space by device driver>>interface. the parser can parse that and do something>>practical function in kernel.>>>>I have worked on a similar task in a product powered by linux. It works great.>> any pointer to the sourcecode so bosko (and others) can profit from that ?>
someone does not want to leak propertied algorithm out with GPL. Thiscan be a way to protect.
>>>> List:       linux-kernel> Subject:    Re: Inserting code from userspace to kernel space> From:       "Shuduo Sang" <sangshuduo () gmail ! com>> Date:       2008-05-22 16:04:35> Message-ID: ee101c360805220904h1c69db12q3048d0347d27c461 () mail ! gmail ! com> [Download message RAW]>> On Thu, May 22, 2008 at 8:41 PM, Bosko Radivojevic> <bosko.radivojevic@gmail.com> wrote:>> Hi!>>>> I'm looking for a way to insert code from user space to the kernel>> space, but without using kernel module. Actually, we are working on a>> system that has to allow end user to change part of code (one or two>> functions) that is executed from the kernel space.>>>> For now we have two different kernel modules, one exporting a function>> which another module uses. Process of compiling kernel module is quite>> ineligible for standard end user (along with the requirement to>> support multi platform cross compiling) compared to just cross>> compiling a simple code that doesn't use any libraries than libc.>>>> I know this sounds quite weird, but maybe there is a project that can help us ;)>>>> actually you can implement a parser/interpretor, whatever you name it,> in kernel space. And you can send the> function code from user space to kernel space by device driver> interface. the parser can parse that and do something> practical function in kernel.>> I have worked on a similar task in a product powered by linux. It works great.>>> Sincerely,>> Bosko>> -->> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in>> the body of a message to majordomo@vger.kernel.org>> More majordomo info at  http://vger.kernel.org/majordomo-info.html>> Please read the FAQ at  http://www.tux.org/lkml/>>> ______________________________________________________________> Jeden Monat 1 hochkarÃ¤tiger maxdome-Blockbuster GRATIS!> Exklusiv fÃ¼r alle WEB.DE Nutzer. http://www.blockbuster.web.de>>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
