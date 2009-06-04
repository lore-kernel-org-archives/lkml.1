Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbZFDQAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbZFDQAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbZFDQAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:00:03 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:53800 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368AbZFDQAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:00:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SMdd7cBk8bvCzVRbN3HtCiPQmawPqY9SM4ih8uY3VSfuYoGwor50wLdlwZj0/4o3t3
         SSWmPv1s0qWX2UxO/LyvKHCdDpitir85hVwAexuN6VadsXvOfCZkayapGnHh96eX7gk+
         O+Q7iQJ3CiH/hfIWDviyIjJRntGo+Wx3S2YH4=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0906040817090.4880@localhost.localdomain>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain>
	 <200906040856.10512.lkml@morethan.org>
	 <200906040958.46018.lkml@morethan.org>
	 <alpine.LFD.2.01.0906040817090.4880@localhost.localdomain>
Date: Thu, 4 Jun 2009 17:00:01 +0100
X-Google-Sender-Auth: b342a5a40c78e0b5
Message-ID: <e9e943910906040900j6f334f29l42a9f5a57e9a1c8f@mail.gmail.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
From: Duane Griffin <duaneg@dghda.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Michael S. Zick" <lkml@morethan.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harald Welte <HaraldWelte@viatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/4 Linus Torvalds <torvalds@linux-foundation.org>:
> On Thu, 4 Jun 2009, Michael S. Zick wrote:
>> Well, that one isn't anything to brag about"
>
> So what's the problem on that machine? Is the VIA C7-M (or some random
> device in it) just buggy and it eventually hangs, or what? Has _any_
> kernel ever worked on that machine for longer than an hour or two?

There have been reports of hangs on various VIA C7 machines going back
a year now. The version of the kernel doesn't seem to matter, but the
version of glibc does. Unfortunately there hasn't been much progress
in getting to the bottom of it.

See here (and other linked reports):
http://bugs.gentoo.org/show_bug.cgi?id=228263

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
