Return-Path: <linux-kernel-owner+w=401wt.eu-S965336AbXC0ULa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965336AbXC0ULa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 16:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965338AbXC0ULa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 16:11:30 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:43050 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965336AbXC0UL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 16:11:29 -0400
Message-ID: <46097A68.6080802@gmail.com>
Date: Tue, 27 Mar 2007 22:11:20 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: johann deneux <johann.deneux@gmail.com>
CC: Dmitry Torokhov <dtor@insightbb.com>,
       =?UTF-8?B?IlNUZW55YUsgKEJydW5vIA==?= =?UTF-8?B?R29uesOhbGV6KSI=?= 
	<stenyak@gmail.com>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom
 driver]
References: <2460126662758025813@fi.muni.cz> <46018FB8.1080601@gmail.com>	 <38b3b7c0703211503s3a8ee177v5b149cfd5975de8c@mail.gmail.com>	 <200703221150.12403.dtor@insightbb.com> <46090BF2.2000105@gmail.com> <38b3b7c0703271136s799114fcndfaa6de8db52fc70@mail.gmail.com>
In-Reply-To: <38b3b7c0703271136s799114fcndfaa6de8db52fc70@mail.gmail.com>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 27 Mar 2007 22:11:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

johann deneux napsal(a):
> On 3/27/07, Jiri Slaby <jirislaby@gmail.com> wrote:
>> Dmitry Torokhov napsal(a):
>> > On Wednesday 21 March 2007 18:03, johann deneux wrote:
>> >> I have forgotten the details of ioctl: Wouldn't the
>> >> following work?
>>
>> No, at least, as far as I understand this. I have computed _torques_, not
>> forces vector (this was misleading info in my first post), the
>> question is
>> "how can I pass torques through plane and direction entries into KS?".
> 
> Torques and forces are both represented as 3d vectors.

Yes, may be.

> Are we
> misunderstanding eachother maybe? By "vector" I mean a triplet of
> numbers, when you say "torques" and "forces vector", do you mean that
> each effect is composed of a bunch of torques?

Ok, let's make things a little bit clear. I need to put somehow 3 short
values (torques -- to tell 3 motors how much to spin around) into the kernel
space via ff layer. I computed them using FP in US from forces (3d vector)
and the problem is, that I don't know how to transform torques to plane(s)
and dir and then back to torques -- this is what I can't figure out, since I
have no longer vector -- 3 values for each axis, which says how big is the
force in each axis -- but I have values (no axis) specific to each motor.

thanks for notes,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
