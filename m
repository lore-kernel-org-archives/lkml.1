Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZEWTNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZEWTNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 15:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZEWTNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 15:13:07 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:42348 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbZEWTNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 15:13:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lMrFpCpf+IeOxeV3qIddKFuRF878WEUKOWl9ZwXwtyYnzV5pM6i9GzLP072tu8Khnb
         SQAPUtUJOMSp1YoJvKSSAoDCxabZqNdaxeekFiIBDBDfX2LQ5foqMa2X+JcgrZ85aBba
         PTnLtVjlzJtpIi+d1q10dJwcSl+T6UOJd46Gw=
Message-ID: <4A184ABB.1070902@jguk.org>
Date: Sat, 23 May 2009 20:12:59 +0100
From: Jon <jg@jguk.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: dd if=/dev/random of=data.bin bs=512 count=1
References: <19ac3f7a0905170822q28255239nea01b56d52e3ddf8@mail.gmail.com> <2f11576a0905170901x41e15f65sf10bb5ee36050d14@mail.gmail.com>
In-Reply-To: <2f11576a0905170901x41e15f65sf10bb5ee36050d14@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello KOSAKI,

Thank you for your reply.

KOSAKI Motohiro wrote:
>> Hello
>>
>> Issuing this command, I expected to get a file 4096 bytes in size.
>> Could someone let me know if I have missed something..? Or is there a
>> problem with using /dev/random this way?
>>
>> if I have a count=10 it hangs forever (several hours).
>>
>> Changing to use /dev/urandom and it generates the file ok.
> 
> you already have the answer. /dev/random might blocked, /dev/urandom doesn't.

Is this a "feature" of /dev/random ? ..it does not seem very useful to 
have it able to block for so long.

Please include my email address in replies,  as I'm not a member of this 
list.

Best regards, Jon
