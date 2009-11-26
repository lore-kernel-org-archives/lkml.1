Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbZKZWGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbZKZWGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 17:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbZKZWGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 17:06:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56301 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbZKZWGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 17:06:11 -0500
Date: 26 Nov 2009 23:05:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: mchehab@redhat.com
Cc: dmitry.torokhov@gmail.com
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: khc@pm.waw.pl
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: superm1@ubuntu.com
Message-ID: <BDccCqq3jFB@christoph>
In-Reply-To: <4B0EEC21.9010001@redhat.com>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+W9AkzAytfc/0D8++Lf882py3Sesd/3z0RanP
 L6p6TMqlqX2m+AyS4OjNPu6rI67ar7bZJQXpMBUopzOOGxJlm2
 rtkjm1AaB7Y0jjS2UNPwmvrqVlfWwtt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

on 26 Nov 09 at 18:59, Mauro Carvalho Chehab wrote:
> Christoph Bartelmus wrote:
[...]
>>> lircd supports input layer interface. Yet, patch 3/3 exports both devices
>>> that support only pulse/space raw mode and devices that generate scan
>>> codes via the raw mode interface. It does it by generating artificial
>>> pulse codes.
>>
>> Nonsense! There's no generation of artificial pulse codes in the drivers.
>> The LIRC interface includes ways to pass decoded IR codes of arbitrary
>> length to userspace.

> I might have got wrong then a comment in the middle of the
> imon_incoming_packet() of the SoundGraph iMON IR patch:

Indeed, you got it wrong.
As I already explained before, this device samples the signal at a  
constant rate and delivers the current level in a bit-array. This data is  
then condensed to pulse/space data.

Christoph
