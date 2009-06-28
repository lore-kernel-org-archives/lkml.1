Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbZF1IGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbZF1IGb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 04:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZF1IGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 04:06:07 -0400
Received: from smtp4.tech.numericable.fr ([82.216.111.40]:45003 "EHLO
	smtp4.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbZF1IGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 04:06:04 -0400
Message-ID: <4A47246A.5060608@numericable.fr>
Date: Sun, 28 Jun 2009 10:06:02 +0200
From: Etienne Basset <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, davem@davemloft.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [REGRESSION] 2.6.29=>2.6.30 suspend to ram regression (IDE 	related)
References: <4A44EBEE.9070503@numericable.fr>	 <200906262139.23367.bzolnier@gmail.com>	 <4A45E095.5070608@numericable.fr>	 <b6a2187b0906271109q2194cadbv8d20b4bda82bde19@mail.gmail.com> <b6a2187b0906271212u78c00562oaf84ffd740d4aecb@mail.gmail.com>
In-Reply-To: <b6a2187b0906271212u78c00562oaf84ffd740d4aecb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua wrote:
> On Sun, Jun 28, 2009 at 2:09 AM, Jeff Chua<jeff.chua.linux@gmail.com> wrote:
>> On Sat, Jun 27, 2009 at 5:04 PM, Etienne
>> Basset<etienne.basset@numericable.fr> wrote:
>>>>> kernel v2.6.29 suspends to RAM reliably on my computer; v2.6.30 doesn't resume after STR
>> Same problem on Thinkpad X61. STD STR suspended ok. Upon resume,
>> everything "seems" fine for about 100 seconds. Then mouse, keyboard
>> frozen.
>>
>>>>> I tried also 2.6.31-rc1 doesn't work either
>>>>> etienne@etienne-desktop:~/linux-2.6$ git bisect bad
>>>>> 2f0d0fd2a605666d38e290c5c0d2907484352dc4 is first bad commit
>>>> Does the following patch fix it?
>>> Yes, it works now
>> Works for me too with the patch.
> 
> UPDATE ...
> 
> STR able to resume and works after >100 seconds
> 
> STD able to resume but failed after 100 seconds (could be 300 seconds)
> but eventually failed. Everything seems ok, but mouse and keyboard
> just freezed suddenly. Just haven't really time it enough.
> 
> Jeff.
> 
Hello,

same here ; after resume, computer hangs after 2minutes (cannot ping from outside)
and STR/resume doesn't work if I try from console not from X
there must be at least one another bug lurking
If someone hasn't a better idea I'll try another bisection, applying bart's patch at each step

Etienne


