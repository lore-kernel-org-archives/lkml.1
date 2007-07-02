Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbXGBTvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbXGBTvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 15:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbXGBTu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 15:50:57 -0400
Received: from bizon.gios.gov.pl ([212.244.124.8]:55290 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbXGBTu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 15:50:56 -0400
Date: Mon, 2 Jul 2007 21:50:46 +0200 (CEST)
From: Krzysztof Oledzki <ole@ans.pl>
X-X-Sender: ole@bizon.gios.gov.pl
To: Phil Dibowitz <phil@ipom.com>
cc: Andreas Steinmetz <ast@domdv.de>, Jan Engelhardt <jengelh@computergmbh.de>,
       netfilter-devel@lists.netfilter.org,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: mss to pmtu clamping partially broken?
In-Reply-To: <20070702193541.GA14961@ipom.com>
Message-ID: <Pine.LNX.4.64.0707022147540.25153@bizon.gios.gov.pl>
References: <4684E853.20900@domdv.de> <Pine.LNX.4.64.0706301034320.22579@fbirervta.pbzchgretzou.qr>
 <4689300C.9050802@domdv.de> <20070702182850.GB14507@ipom.com>
 <Pine.LNX.4.64.0707022113330.25153@bizon.gios.gov.pl> <20070702193541.GA14961@ipom.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-593621854-1183405846=:25153"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-593621854-1183405846=:25153
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 2 Jul 2007, Phil Dibowitz wrote:

> On Mon, Jul 02, 2007 at 09:16:57PM +0200, Krzysztof Oledzki wrote:
>>
>>
>> On Mon, 2 Jul 2007, Phil Dibowitz wrote:
>>
>>> On Mon, Jul 02, 2007 at 07:04:12PM +0200, Andreas Steinmetz wrote:
>>>> Jan Engelhardt wrote:
>>>>> Do you really need clamping? It's a hack, since TCP should do MSS
>>>>> negotiation
>>>>> itself. (Of course it may happen that some routers are broken.) But
>>>>> usually not
>>>>> for incoming packets.
>>>>
>>>> You never know when you hit ICMP blackholes, broken routers and other
>>>> evil things. Better safe than sorry so clamping is the way to go for m=
e.
>>>
>>> I encourage you to report PMTUD Blackholes to the MSS Initiative at
>>> http://www.phildev.net/mss/
>>
>> Any chances for similar initiative for "SACK vandals"? ;)
>
> There's already a counterpart for ECN blackholes, so I'm not opposed to i=
t.
> However, keeping up with new reports, re-testing existing offenders, etc.
> takes up a good chunk of time, so I don't have the time to do it myself. =
I'm
> happy to reference such a site, however.

Indeed and it seems there are more important issues, like similar window=20
scaling problem for example. :(

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-593621854-1183405846=:25153--
