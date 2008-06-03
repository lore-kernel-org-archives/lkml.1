Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbYFCIKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbYFCIKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 04:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYFCIKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 04:10:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:29922 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYFCIKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 04:10:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eb5r+NqJvHASmyFPn7rjkrHFFWVOHocjciHqyALy2Ik7JSFaz+FAgR8CN/NXr5H7s1EMO5IOW+2G3KA3w1iiTapXh77ojZC8pyBGZtWL31G+mRP31N5QUIABxX+vG0PHTRg4FHA8rR5iisGO5CoVHcJ8xOqjcPDwXzt/jIp8TX0=
Message-ID: <c4e36d110806030110t3e4f406fy4d3afe6c74362501@mail.gmail.com>
Date: Tue, 3 Jun 2008 10:10:10 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Suspend to memory is freezing my machine
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <c4e36d110805262344r16c64f3dweb127c7fd0fc8f36@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110805040037u1b98c027x46dc17bf6be5da5b@mail.gmail.com>
	 <200805242301.25695.rjw@sisk.pl>
	 <c4e36d110805250159x34e667f2kcfbc01a7b87dda29@mail.gmail.com>
	 <200805251424.49186.rjw@sisk.pl>
	 <c4e36d110805262344r16c64f3dweb127c7fd0fc8f36@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/27 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> 2008/5/25 Rafael J. Wysocki <rjw@sisk.pl>:
>> On Sunday, 25 of May 2008, Zdenek Kabelac wrote:
>>> 2008/5/24 Rafael J. Wysocki <rjw@sisk.pl>:
>>> > On Thursday, 22 of May 2008, Zdenek Kabelac wrote:
>>> >> Hello Rafael
>>> >>
>>> >>
>>
>> If you use s2ram, please check if "echo mem > /sys/power/state" works instead.
>
> The problem occurs also with plain echo 'mem' - I've already checked before.
> Just resently I've discovered that actually I've had some serious
> problem with CONFIG_DEBUG_PAGEALLOC option. Unsure if this thing could
> be related to my deadlocking problem during suspend - I'll watch, if
> the freeze will be still ocurring even without this option.
>
> I'll make probably a separate post about my debug option problem.

Hello

It looks like from the time I've disabled CONFIG_DEBUG_PAGEALLOC
option I've not seen a single freeze during the suspend - I'll
continue to watch this - but I guess it's the key part of my problem.

Zdenek
