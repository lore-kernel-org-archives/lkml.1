Return-Path: <linux-kernel-owner+w=401wt.eu-S1760464AbXGENAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464AbXGENAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 09:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758380AbXGEM74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 08:59:56 -0400
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:22328 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339AbXGEM7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 08:59:55 -0400
Date: Thu, 5 Jul 2007 14:59:53 +0200 (CEST)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: Adrian Bunk <bunk@stusta.de>
cc: Darren <kernel@da4.org>, Hannu Savolainen <hannu@opensound.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
In-Reply-To: <20070704173228.GK3492@stusta.de>
Message-ID: <Pine.BSO.4.63.0707051443410.21083@rudy.mif.pg.gda.pl>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
 <468B3FBB.9050006@da4.org> <20070704173228.GK3492@stusta.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-208671709-1183639864=:21083"
Content-ID: <Pine.BSO.4.63.0707051451180.21083@rudy.mif.pg.gda.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-208671709-1183639864=:21083
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.BSO.4.63.0707051451181.21083@rudy.mif.pg.gda.pl>

On Wed, 4 Jul 2007, Adrian Bunk wrote:

> On Wed, Jul 04, 2007 at 02:35:39AM -0400, Darren wrote:
>>
>> I know this may sound kind of stupid, but how about not deprecating either,
>> and fully supporting both sound systems? Maybe we can get them to work
>> together, and the distro or user can choose whether they would like to use
>> alsa or oss for that particular card (or have the distro choose the sound
>> drivers that are best supported for that particular card). As it is now,
>> most apps already support oss and alsa.
>
> It does not sound stupid and sounds good at first sight.
>
> But there are problems we've already seen with similar situations in
> different parts of the kernel:
>
> They would have different hardware support, features and bugs.
>
> And then a user user whose sound card is only supported by sound system A
> needs a feature only available in sound system B.
>
> And the quality decreases since people will often not report bugs in
> sound system A if sound system B works for them.
>
> OTOH, for a user it shouldn't matter whether there's OSS or ALSA, that's
> mostly a difference for application developers. And since (as you say)
> most applications already support both, there's no compelling reason for
> providing more than one of them.

>From Hannu message:
"I think the ideal solution would be that both ALSA and OSS APIs can 
co-exist by sharing the same low level drivers (which has
already been demonstrated). The low level driver interfaces in both 
systems are practically identical. This means that ALSA's
core can work with OSS' drivers and vice versa."

So Hannu have plan for share ALSA low level drivers without changes 
(porting to OSS will not be neccessary and/or will need only small 
amount of time .. IMO much less than make ALSA fully functional).
Main diffrences between ALSA and OSS are above low level drivers so IMO it 
is completly possible have ALSA and OSS in the same tree.
OSS wtil not dies (and try resurect) ALSA still (after few years) was not 
born and still isn't rock solid point odf Linux desktop (IMO it is most 
weeknes ponit of LD). IMO it will be better if Hannu will start pushing 
any OSS chages to Linus tree. Current OSS code in Linus tree is more or 
less not useable so allow maintain this code in main tree can't hurd 
anything outside this area.

kloczek
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko, sys adm @zie.pg.gda.pl|*e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-208671709-1183639864=:21083--
