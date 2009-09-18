Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbZIRFLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbZIRFLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 01:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbZIRFLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 01:11:47 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:35316 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbZIRFLr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 01:11:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vpb13MFZ3zwxixVDAJUIwVDbVmUcR6BZOdcGmpMmAxGPLpbZbO3jso+Hp+Cy/O3xmB
         a/w0VJ3jIKJ8p5ceODzst780Vgm0vCiumQ9v9kWjfjr0EF7wxlr6+LSf/cM65+R6yaSV
         sRo8LLV5H0lhHlNwv+DTtSz6qbfRNDkqAZX1w=
MIME-Version: 1.0
In-Reply-To: <4e5ebad50909172154m3c6450f2u7512f20ee3f1951e@mail.gmail.com>
References: <1253095348.25791.6.camel@eight.analog.com>
	 <8bd0f97a0909161156x3cf83b51tb01f6c890abf8594@mail.gmail.com>
	 <4e5ebad50909172154m3c6450f2u7512f20ee3f1951e@mail.gmail.com>
Date: Fri, 18 Sep 2009 13:11:50 +0800
Message-ID: <4e5ebad50909172211s309cfcdbl7edd904178996799@mail.gmail.com>
Subject: Re: [PATCH][uart] fit blackfin uart over sport driver into common 
	uart inftrastructure (v2)
From: Sonic Zhang <sonic.adi@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Serial <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 12:54 PM, Sonic Zhang <sonic.adi@gmail.com> wrote:
> On Thu, Sep 17, 2009 at 2:56 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
>>
>> then we get proper device bindings between ttySS# and SPORT# by using
>> the .id field.  ttySS0 should always be SPORT0, ttySS1 should always
>> be SPORT1, etc...
>
> You can't either. Because the index of tty devices is increased
> automatically when you successfully register a uart port.  If sport0
> is used for devices other than uart, uart over sport1 is always bond
> to ttySS0.
>
>
OK. This looks possible. I will take a look.

Sonic
