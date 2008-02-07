Return-Path: <linux-kernel-owner+w=401wt.eu-S1760277AbYBGOZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277AbYBGOZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 09:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbYBGOZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 09:25:43 -0500
Received: from otello.alma.unibo.it ([137.204.24.163]:55146 "EHLO
	otello.alma.unibo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbYBGOZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 09:25:42 -0500
Message-ID: <47AB14E4.6080100@otello.alma.unibo.it>
Date: Thu, 07 Feb 2008 15:25:40 +0100
From: Diego Zuccato <diego@otello.alma.unibo.it>
User-Agent: Thunderbird 2.0.0.9 (X11/20080114)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>            <20080202123710.42df1aa0@weinigel.se>            <20080202191930.GA19826@kroah.com>            <47A5D895.20300@davidnewall.com>            <47A6E742.80408@otello.alma.unibo.it> <courier.47A8F072.000079E4@hawking.rebel.net.au> <47AAC1EE.6060101@otello.alma.unibo.it> <47AB0911.3060508@davidnewall.com>
In-Reply-To: <47AB0911.3060508@davidnewall.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall ha scritto:

> That's naive, since requirements differ in different jurisdictions, as
> I'm sure you are perfectly aware.
Naive? Who thinks a limit can be enforced by sw is naive!
He's missing a little detail: Internet. :-)

> Precisely: One purpose of the driver is to enforce local compliance.
It can't *enforce* it anyway, at least if the users are all around the 
world. At most it can *suggest*. Then it's up to the user to make sure 
to meet the local laws.

>> But linear amplifiers are commonly sold. And (at least in Italy) it's
>> not illegal to buy one, even if it can boost antenna power to 1000W.
>> It's illegal just to USE it.
> In Australia it's illegal to own them (CB licensee; HAMs are allowed to
> use them, although not on 27Mhz.)
Then Australian shops can ask for the licence. And what about online 
shops? Ebay? They'll send you an unmarked package (same as letting you 
download another country's driver). The result is that you can have your 
LA more easyly than going to a local shop or tampering with your CB (or 
tampering whith the local version of the driver).

>> And it's a logical problem, too: why should the *driver* enforce a
>> *technical* limit?
> That's part of it's purpose.  It permits a manufacturer to make a global
> device that operates within local restrictions.
Nope. The driver should simply make the device WORK. The USER must make 
sure to meet the local regulations. The driver can help, but as long as 
it asks the user a country setting, its enforcement is nearly nothing! 
The simpler way for the user to trick it into using illegal settings is 
simply to lie! It's like if your LA had a switch on it, allowing you to 
select the country.
Another example. Think about what happens if you're right: the user gets 
caught with a WiFi card operating on an illegal channel, but the system 
appears correctly configured (location-wise). When analyzed, it turns 
out that, due to a bug in the driver, the card uses that channel (for 
example 13) because the user only changed the country setting when 
flying back from Japan (where he used channel 13) and channel limiter 
didn't kick in. Is the manufacturer responsible?
If you're right, he is and must pay, remove that device from shops and 
replace sold ones. Or at least make sure all users update their drivers 
with others without that bug...
A real can of worms...

BYtE,
  Diego.
