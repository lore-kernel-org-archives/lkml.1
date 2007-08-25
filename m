Return-Path: <linux-kernel-owner+w=401wt.eu-S934271AbXHYSlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271AbXHYSlu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 14:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758238AbXHYSln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 14:41:43 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:36979
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258AbXHYSlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 14:41:42 -0400
Date: Sat, 25 Aug 2007 11:32:49 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH -mm 2/2] Hibernation: Arbitrary boot kernel support on
 x86_64
In-Reply-To: <200708252027.26721.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0708251132070.22470@asgard.lang.hm>
References: <200708241206.57178.rjw@sisk.pl> <200708241211.55319.rjw@sisk.pl>
 <20070824204632.GA5008@ucw.cz> <200708252027.26721.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-1005720952-1188066769=:22470"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-1005720952-1188066769=:22470
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Sat, 25 Aug 2007, Rafael J. Wysocki wrote:

> On Friday, 24 August 2007 22:46, Pavel Machek wrote:
>> Hi!
>>
>>> From: Rafael J. Wysocki <rjw@sisk.pl>
>>>
>>> Make it possible to restore a hibernation image on x86_64 with the help of a
>>> kernel different from the one in the image.
>>>
>>> The idea is to split the core restoration code into two separate parts and to
>>> place each of them in a different page.  The first part belongs to the boot
>>
>> What happens in case where both parts want to be
>> at the same place? (Like kernel being restored is 4KB smaller, so that
>> routines now collide?)
>
> Bad things, but I can't see how to avoid that reliably.

can you at least detect it reliably? (feed a program both kernel images 
and have it tell you 'yes/no')

David Lang
--680960-1005720952-1188066769=:22470--
