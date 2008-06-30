Return-Path: <linux-kernel-owner+w=401wt.eu-S933162AbYF3WtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162AbYF3WtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 18:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763469AbYF3Wsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 18:48:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51045 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763413AbYF3Wsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 18:48:55 -0400
Message-ID: <48696209.2090801@zytor.com>
Date: Mon, 30 Jun 2008 15:45:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Sean Young <sean@mess.org>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: Regression: boot failure on AMD Elan TS-5500
References: <20080616121138.GA51097@atlantis.8hz.com> <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com> <20080630214347.GA57988@atlantis.8hz.com> <4869558A.9020907@goop.org> <48695871.8000805@zytor.com> <48695ACE.9040806@zytor.com> <48695FD5.7000605@goop.org>
In-Reply-To: <48695FD5.7000605@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> On this general subject... I keep thinking that it would be better to 
>> have this as:
>>
>>     movl    %cs, %eax
>>     addl    $8, %eax
>>     movl    %eax, %cs
> 
> What's your intent?  You can't directly load %cs; do you mean the other 
> segment registers?
> 
> 
> Oh, you mean
> 
>     mov %cs, %eax
>     add $8, %eax
>     mov %eax, %ds (etc)
> ?
> 
> Seems reasonable.
> 

Uhm, yeah ;)

	-hpa
