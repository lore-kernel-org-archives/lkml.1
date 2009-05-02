Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbZEBLUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbZEBLUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 07:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZEBLUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 07:20:45 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:33293 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbZEBLUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 07:20:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oUgWO8ccIHJWaL38bFOG2tfkIppZMlt0jqsOibWri9/ak78OF2edKUaPgu+wopvNPg
         nKRYdDRb5V8kgzftAEEKs0OPbChYiv9wKhP0BR+OBQQuZXixJ6IsQhISTjau4TNw6n2o
         wueWQR2Qk12bOaqBrd49xAPV3tXzmL4CIUJ9c=
MIME-Version: 1.0
In-Reply-To: <1241252825.13562.20.camel@johannes.local>
References: <f7848160904301838q4883106fq8d31e2e7c0b10a14@mail.gmail.com>
	 <1241165805.13562.2.camel@johannes.local>
	 <f7848160905011328o68010ba0rf8e18fa7ce88c7b5@mail.gmail.com>
	 <1241252825.13562.20.camel@johannes.local>
Date: Sat, 2 May 2009 07:20:44 -0400
Message-ID: <f7848160905020420t114db70dq4018bab2ab53fc8f@mail.gmail.com>
Subject: Re: Probe Timeouts with 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8
From: Parag Warudkar <parag.lkml@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, niel.lambrechts@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/09, Johannes Berg <johannes@sipsolutions.net> wrote:
> Parag,
>
>> Just got around to downloading today's compat-wireless and it doesn't
>> work for me - frequent disconnects this time with response timeouts -
>>
>>  9731.902114] wlan1: RX ReassocResp from 00:1e:e5:6a:2c:c2
>> (capab=0x411 status=0 aid=1)
>> [ 9731.902117] wlan1: associated
>> [ 9886.744022] wlan1: no probe response from AP 00:1e:e5:6a:2c:c2 -
>> disassociating
>> [ 9887.594299] wlan1: authenticate with AP 00:1e:e5:6a:2c:c2
>> [ 9887.596953] wlan1: authenticated
>> [ 9887.596958] wlan1: associate with AP 00:1e:e5:6a:2c:c2
>> [ 9887.600997] wlan1: RX ReassocResp from 00:1e:e5:6a:2c:c2
>> (capab=0x411 status=0 aid=1)
>> [ 9887.601000] wlan1: associated
>> [ 9930.640019] wlan1: no probe response from AP 00:1e:e5:6a:2c:c2 -
>> disassociating
>
> This looks like something entirely different.
>
>> Of course mainline continues to work fine after reverting
>> 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8.
>
> Can you make sure the txpower is set correctly, on your compat? Just say
> "iwconfig wlan0" or whatever _while_ associated -- and check that it
> reports 15dBm or so.

It shows 27 dBm when associated - both for mainline and compat.
Still get the disassociated messages.

wlan1     IEEE 802.11bgn  ESSID:"pbwloft2"
          Mode:Managed  Frequency:2.447 GHz  Access Point: 00:1E:E5:6A:2C:C2
          Bit Rate=1 Mb/s   Tx-Power=27 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:21F9-23AF-AEBB-A427-4ADC-8596-C915-ADC8 [2]
Security mode:open
          Power Management:on
          Link Quality=38/70  Signal level=-72 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

Parag
