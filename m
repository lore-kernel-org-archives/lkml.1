Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbYIUBsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbYIUBsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 21:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYIUBsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 21:48:09 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:61709 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbYIUBsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 21:48:08 -0400
Message-ID: <f488382f0809201848w1e59cc19i8235c7c74c44fc10@mail.gmail.com>
Date: Sat, 20 Sep 2008 18:48:05 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Senthilkumar Balasubramanian" 
	<Senthilkumar.Balasubramanian@atheros.com>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <f488382f0809201448l21434f11n12311e308f9952d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
	 <43e72e890809191813n95579f5h83e92b0ba1f95a44@mail.gmail.com>
	 <f488382f0809192029w601e0e72x5c3affc3dbe65118@mail.gmail.com>
	 <f488382f0809200821m6fe355feu2d9fb99ac3c7f712@mail.gmail.com>
	 <43e72e890809201357y1413a151r85aad7cc16440cf4@mail.gmail.com>
	 <1221944338.3023.8.camel@johannes.berg>
	 <43e72e890809201403w2c4511fdv2fe26bbcf49ccdd7@mail.gmail.com>
	 <f488382f0809201422rdabeff4g435bf3d4a7e9fa3@mail.gmail.com>
	 <43e72e890809201426x61c94bfej2dcda1c178be81b@mail.gmail.com>
	 <f488382f0809201448l21434f11n12311e308f9952d7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 2:48 PM, Steven Noonan <steven@uplinklabs.net> wrote:
> On Sat, Sep 20, 2008 at 2:26 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Sat, Sep 20, 2008 at 2:22 PM, Steven Noonan <steven@uplinklabs.net> wrote:
>>
>>> Heh. I don't have an Xbox 360 or PS3 (sad, I know). Do have several
>>> 2.4GHz phones. ;)
>>
>> Microwaves are the best to make the signal wet poop BTW, if you have
>> that option available. Not sure if we can trigger the device that way
>> but I'm just brainstorming here.
>>
>
> Well, I've got the thing set to ATH_DBG_ANY (I want this damn bug
> found!), which will certainly be *interesting*. In 5 minutes, the log
> has jumped 9 megabytes.
>
> I've also got sadc monitoring IRQs so I know for certain when the
> interrupt storm starts.
>
> I'll let you know how this goes.

OK, here's the time index at which it b0rked:

18:28:38          sum   1106.00
18:28:39          sum   1037.62
18:28:40          sum   1069.00
18:28:41          sum   1167.00
18:28:42          sum   1155.00
18:28:43          sum   1339.00
18:28:44          sum  18355.00
18:28:45          sum  17845.45
18:28:46          sum  15285.00
18:28:47          sum  17511.00
18:28:48          sum  17568.69
18:28:49          sum  17704.04
18:28:50          sum  18566.67
18:28:51          sum  18913.13

And the entire log of the minute 18:28 is here:
http://www.uplinklabs.net/~tycho/linux/18.28.00-59.log.gz

It looks pretty crazy.

- Steven
