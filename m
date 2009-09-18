Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbZIRGYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbZIRGYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 02:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbZIRGYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 02:24:33 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:48523 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbZIRGYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 02:24:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=T7ICFwlicwirWfrvrFWOdbSm48KbSu6WmhUzEpU2rHF9tOPBfL0a823zzM6KwQKRev
         H+DPbn3xp1yZD4qVjcwpMMtmbVpxtzhoRL3kGtKgszci3JrP5huxKXm2k5B0ZgPdHrKC
         D4fdUzpNMxk/foB7a3GlEgWn/T60hRjrPHLqM=
MIME-Version: 1.0
In-Reply-To: <4e5ebad50909172154m3c6450f2u7512f20ee3f1951e@mail.gmail.com>
References: <1253095348.25791.6.camel@eight.analog.com> <8bd0f97a0909161156x3cf83b51tb01f6c890abf8594@mail.gmail.com> 
	<4e5ebad50909172154m3c6450f2u7512f20ee3f1951e@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 18 Sep 2009 02:24:16 -0400
Message-ID: <8bd0f97a0909172324j32331e6ele1435cd93de188c@mail.gmail.com>
Subject: Re: [PATCH][uart] fit blackfin uart over sport driver into common 
	uart inftrastructure (v2)
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Serial <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 00:54, Sonic Zhang wrote:
> On Thu, Sep 17, 2009 at 2:56 AM, Mike Frysinger wrote:
>> On Wed, Sep 16, 2009 at 06:02, sonic zhang wrote:
>>> 3. Move most platform data into arch specific board files.
>>
>> might as well do it right now since you've done most of it already.
>> i.e. all of the peripheral logic should be in the boards, not the
>> driver.  so the bfin_uart_pin_req_sportx lists should get moved to the
>> platform resources as well as the SPORT base addresses.
>
> No. You can't. Because the console is registered and running much
> earlier than the platform data is initialized. You have to know the
> peripheral lists and base address before registering the console.

this is why the early_platform_driver framework was created.  i was
looking into adding this to the Blackfin serial driver.  check out
Documentation/driver-model/platform.txt.

>>> Signed-off-by: Michael Frysinger <michael.frysinger@analog.com>
>>
>> you shouldnt add s-o-b tags for people who didnt opt for them ... i
>> was sleeping when you wrote, committed, and e-mailed out these
>> changes.  i also handt posted these changes yet because i knew there
>> were still issues to be worked out.
>
> OK. I mean you also did some cleanup to this patch.

well once we get these issues hashed out, i'm happy to say the code is
good stuff ;)
-mike
