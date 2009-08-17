Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbZHQI6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbZHQI6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbZHQI6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:58:13 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:62232 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428AbZHQI6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:58:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=YdWuZauQ7tlS3AQIw3oQX2MUbQgIg4ylDFAHH1Zwq9P4LSGReNsSWOi5XHvvaFgAum
         +mhj/1kJ8854dSQO+38QKSie1kIjfB/W7w3acL6A4xr0DWZwHyPVBthjbef41KiIIicl
         jODNM3MtsNXhDEpJO87EnvRv36yRzw4Qic0a8=
MIME-Version: 1.0
In-Reply-To: <200908141344.50639.arnd@arndb.de>
References: <4A842B32.5030401@lumino.de> <200908131839.41803.arnd@arndb.de> 
	<4A85327D.2040003@lumino.de> <200908141344.50639.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 17 Aug 2009 04:57:53 -0400
Message-ID: <8bd0f97a0908170157m71e4ffafna9e1afbb214655cc@mail.gmail.com>
Subject: Re: implementing Futex
To: Arnd Bergmann <arnd@arndb.de>
Cc: Michael Schnell <mschnell@lumino.de>, linux-kernel@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 07:44, Arnd Bergmann wrote:
> On Friday 14 August 2009, Michael Schnell wrote:
>> Does that mean that both in fact do run in the same mode (I suppose
>> Kernel Mode and thus the CPU's "System Mode" rather than the CPU's "User
>> Mode".
>
> yes
>
>> With that - and supposing that as of Kernel 2.6.31 the sh code I see in
>> Kernel 2.6.30 is used in /asm/generic, I would be able to just use the
>> "generic" case for "implementing" a working Futex syscall for the NIOS).
>
> Well, I haven't put that code into asm-generic/futex.h yet and it's
> too late for 2.6.31, but it should get there eventually, if one of us
> four submits a tested patch ;-).

well, that thread stalled because i posted a question wrt spinlock/irq
usage and didnt get a response ...
-mike
