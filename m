Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbYIZSxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbYIZSxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 14:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYIZSxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 14:53:12 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:61531 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbYIZSxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 14:53:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bUkSwcMXD3A8Scy3tSuJa2g2OaXYVMjpv2FndFAi6sirTo46ukNSSwa4lS2I2Ts+i7
         FP2VyRLifdlZ5h5wO52F5TwFnHf8L7PTCAapCcXDzjvRhXhFfalTsjY6DhGf5sCo8De2
         DlNlH2WuiZ+JBoUU2C5Licj6QPo4whhHOFeWY=
Message-ID: <c384c5ea0809261153t2c3a73c2sb46979962e8d1f8c@mail.gmail.com>
Date: Fri, 26 Sep 2008 20:53:09 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: [PATCH] init: bzip2 or lzma -compressed kernels and initrds
Cc: "Bill Davidsen" <davidsen@tmr.com>,
       "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>,
       "Rob Landley" <rob@landley.net>, "Willy Tarreau" <w@1wt.eu>,
       "Alain Knaff" <alain@knaff.lu>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <f488382f0809151028w4b5b8a2bs86025e9286cfffe7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809062119.m86LJ5Of026101@hitchhiker.org.lu>
	 <20080907054831.GA2244@1wt.eu> <200809142037.48204.rob@landley.net>
	 <ac9c93b10809150546w7644316bk53122b0ce5021ff4@mail.gmail.com>
	 <48CE97BA.1060901@tmr.com>
	 <f488382f0809151028w4b5b8a2bs86025e9286cfffe7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On Mon, Sep 15, 2008 at 7:28 PM, Steven Noonan <steven@uplinklabs.net> wrote:
> On Mon, Sep 15, 2008 at 10:13 AM, Bill Davidsen <davidsen@tmr.com> wrote:
>> Frans Meulenbroeks wrote:
>>>
>>> For kernel/ramfsimage etc the best choice is the one that has the
>>> fastest decompression (info on tukaani.org says gzip).
>>> Rationale: as it uncompresses faster the system will boot faster.
>>> ...
>
> It all really depends on what you're prioritizing.

Exactly.

Whenever LZMA comes up people start discussing the differences and
then discuss what is THE best.
So far, IMHO there is NONE. Selecting the best filesystem is about
making trade-offs depending on what you need.

For example, the systems I use squashfs for, are intended to be booted
only *once* (or incidently after a firmware upgrade). I do not care
about the memory it takes, or if takes twice as long. Also, I need the
rootfs to be read-only. Distributing over any media and uploading
Linux/FPGA firmware over very slow device backplanes is my main
concern.
Squashfs w/ LZMA works best for me, because smallest. Kudos.

Linux, THE best if you need choice.

Regards,
-- 
Leon
