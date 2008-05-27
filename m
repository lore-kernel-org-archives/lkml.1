Return-Path: <linux-kernel-owner+w=401wt.eu-S1756987AbYE0Gor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbYE0Gor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 02:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbYE0Goj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 02:44:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:18640 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727AbYE0Goi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 02:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N0jAD5AyGTJHV1iDYr7c2o60uumoPqrfLFOVL5v+sFSwr79JWImCsju93IMG6tb9t+nCe2iwZwu/1wEMxSxAjZzj8HCaQt4UysCG9m2phM2aeaDVODckwwrEP28l70yHD2eVReDDTOBYVi/HeCnWfkvsNzxhdUo1ay0X0jrGXHQ=
Message-ID: <c4e36d110805262344r16c64f3dweb127c7fd0fc8f36@mail.gmail.com>
Date: Tue, 27 May 2008 08:44:37 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Suspend to memory is freezing my machine
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200805251424.49186.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110805040037u1b98c027x46dc17bf6be5da5b@mail.gmail.com>
	 <200805242301.25695.rjw@sisk.pl>
	 <c4e36d110805250159x34e667f2kcfbc01a7b87dda29@mail.gmail.com>
	 <200805251424.49186.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/25 Rafael J. Wysocki <rjw@sisk.pl>:
> On Sunday, 25 of May 2008, Zdenek Kabelac wrote:
>> 2008/5/24 Rafael J. Wysocki <rjw@sisk.pl>:
>> > On Thursday, 22 of May 2008, Zdenek Kabelac wrote:
>> >> Hello Rafael
>> >>
>> >> 2008/5/4 Rafael J. Wysocki <rjw@sisk.pl>:
>> >> > On Sunday, 4 of May 2008, Zdenek Kabelac wrote:
>> >> >> Hello
>> >> >
>> >> > Hi,
>> >> >
>> >> >> With recent 2.6.25 & 2.6.26-rc1 git (around 1 week) I get occasionally
>> >> >> complete freeze of my T61 during suspend. (dual core, 2GB).
>> >> >
>> >> > How reproducible is this?
>> >> >
>> >>
>> >> The problem happens still even with -rc3. Now I've an update:
>> >>
>> >> Usually I've to run the machine for couple hours to actually be able
>> >> to hit this lock.
>> >> (Usually after a day work when I want to leave)
>> >>
>> >> I've also noticed that when I run the suspend after the reboot I
>> >> usually cannot see the suspend freeze - mostly because either the
>> >> mashine crashes from other ooops or I do another reboot.
>> >>
>
> If you use s2ram, please check if "echo mem > /sys/power/state" works instead.

The problem occurs also with plain echo 'mem' - I've already checked before.
Just resently I've discovered that actually I've had some serious
problem with CONFIG_DEBUG_PAGEALLOC option. Unsure if this thing could
be related to my deadlocking problem during suspend - I'll watch, if
the freeze will be still ocurring even without this option.

I'll make probably a separate post about my debug option problem.

Zdenek
