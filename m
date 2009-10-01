Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbZJASXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbZJASXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 14:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbZJASXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 14:23:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40018 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbZJASXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 14:23:48 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AC4F3B0.6080202@s5r6.in-berlin.de>
Date: Thu, 01 Oct 2009 20:23:44 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090926 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Nathaniel McCallum <nathaniel@natemccallum.com>
CC: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: Exposing device ids and driver names
References: <4AC4DB65.8070404@natemccallum.com> <4AC4EB2E.4050907@s5r6.in-berlin.de> <4AC4EEB2.8090904@natemccallum.com>
In-Reply-To: <4AC4EEB2.8090904@natemccallum.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathaniel McCallum wrote:
> On 10/01/2009 01:47 PM, Stefan Richter wrote:
>> Nathaniel McCallum wrote:
[...]
>>> The second tool, related to the first, is a program which runs on
>>> Windows and scans for a user's hardware and tells them which distro will
>>> best support their hardware.
[...]
>> Hardware support also depends on userland:  Udev rules, libraries,
>> application programs.
>>
>> Even if you ignore that for now and only look at the kernel part of
>> hardware support:  Beyond "doesn't have a matching driver" and "does
>> have", there is a large and impossible to track grey area of "has a
>> poorly working driver" and "has a perfectly working driver".

There are even more factors for how well something works or even whether
it works at all:  It may even depend on combinations of two pieces of
hardware, e.g. bus adapter and device on that bus.  It may depend on
device firmware revisions.

> Yes, I'm aware of this and will account for it as best as I am able.
[...]
> you are correct that we cannot predict 100% of user
> experience.  But 70% is a huge improvement over 0%.

So, this 2nd tool can't literally say which distribution supports a
device best.  It can mostly just list which distributions contain a
matching kernel driver.
-- 
Stefan Richter
-=====-==--= =-=- ----=
http://arcgraph.de/sr/
