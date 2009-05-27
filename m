Return-Path: <linux-kernel-owner+w=401wt.eu-S1762852AbZE0Tyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762852AbZE0Tyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762487AbZE0TyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:54:24 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:55926 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933556AbZE0TyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:54:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AZoeU1e3FKhY91p7GtzGDCf3uR9QzUmvX0Rb6Y6i0CSscI5XJ+rNTpa7IE4Ula8qwh
         QgDJj1uHjtxYUdvK1fBe1ofileQiQ+z9ZjmgME1RlaKamokTOJf3dEZyEvwDlAgxGy4j
         ov1cfO+QE83J8Rq4ulvy7fsKRd64nwzkFDfIk=
Message-ID: <4A1D9A4C.4000600@gmail.com>
Date: Wed, 27 May 2009 21:53:48 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>
Subject: Re: 2 bugs related to suspend to disk
References: <4A199A7A.3010705@gmail.com> <200905250004.11927.rjw@sisk.pl> <4A1AD3D1.2010806@gmail.com> <200905252331.02488.rjw@sisk.pl>
In-Reply-To: <200905252331.02488.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote
> On Monday 25 May 2009, Marcin Slusarz wrote:
>> Rafael J. Wysocki wrote:
>>> On Sunday 24 May 2009, Marcin Slusarz wrote:
>>>> Pavel Machek wrote:
>>>>> Hi!
>>>>>
>>>>>
>>>>>> 2) "s2disk" (from suspend-0.8) suspends, but doesn't resume (and I need to mkswap && swapon -a later)
>>>>>>
>>>>> I'm afraid we need more details here. Is "resume" binary being ran?
>>>> Excellent question ;) - I didn't know it has to. I'll try to setup
>>>> initramfs tomorrow.
>>>>
>>>> Thanks and sorry for the noise!
>>> However, the issue reported as 1) is not really a noise IMO. :-)
>>>
>>> Can you please attach a full dmesg output containing these messages?
>> I've uploaded .config, dmesg (BUG was not saved) and 2 pictures of
>> screen just before power loss to http://www.kadu.net/~joi/kernel/2009.05.25/
>> (Please ignore first suspend failure (3681.078646 - 3685.514358) - I forgot
>> to restore swap)
> 
> Thanks.
> 
> Can you please test the patch sent by Sebastian Ott in this thread?

BUG disappeared with this patch. Is this a final fix?

Marcin
