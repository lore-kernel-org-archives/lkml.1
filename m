Return-Path: <linux-kernel-owner+w=401wt.eu-S933822AbXC1WQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933822AbXC1WQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 18:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933859AbXC1WQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 18:16:28 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:37377 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933822AbXC1WQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 18:16:28 -0400
Message-ID: <460AE933.6010209@gmail.com>
Date: Thu, 29 Mar 2007 00:16:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>
CC: johann deneux <johann.deneux@gmail.com>,
       =?UTF-8?B?IlNUZW55YUsgKEJydW4=?= =?UTF-8?B?byBHb256w6FsZXopIg==?= 
	<stenyak@gmail.com>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom
 driver]
References: <2460126662758025813@fi.muni.cz> <460983D6.7070409@gmail.com> <38b3b7c0703271434u2fddc4d1jc2b9af097e9c95b2@mail.gmail.com> <200703272308.34441.dtor@insightbb.com>
In-Reply-To: <200703272308.34441.dtor@insightbb.com>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 29 Mar 2007 00:16:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov napsal(a):
> On Tuesday 27 March 2007 17:34, johann deneux wrote:
>> What about adding a member to ff_effect which would be the number of the motor?
>> We can't change the layout of ff_effect too much though, so we have to
>> find unused bits and put them to work.
>>
>> For instance, we could replace
>>
>> __u16 type;
>>
>> by
>>
>> __u8 motor;
>> __u8 type;
>>
> 
> Splitting type field seems to be a good idea.

Maybe stupid question, but what about endianness + backward compatibility?
If we split it into motor,type sequence, it would break LE (untouched BE),
if we do type,motor, it is OK for LE (broken BE).

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
