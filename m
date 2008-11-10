Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbYKJVeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbYKJVeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 16:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbYKJVeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 16:34:05 -0500
Received: from ik-out-1112.google.com ([66.249.90.177]:44234 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYKJVeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 16:34:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IakkQ013njOMBsTFw3aHH1iBjuP6246x1cwc0bEvzy31eEtHcpLtLYZ4G99Aulu6zG
         T2rcAw0x4CGX2+/BILoHGfv2WvgTq9tPmnG34uYG+i6eu6faGh2JXfA4E2TcmzIirUTC
         MfTrKJB2Lg9C/PS6EblEiTljeuH+D4ehERRM0=
Message-ID: <4918A8C5.3050607@gmail.com>
Date: Mon, 10 Nov 2008 23:33:57 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       ath5k-devel@venema.h4ckr.net, alsa-devel@alsa-project.org
Subject: Re: Bugs on aspire one A150
References: <491506DB.1070000@gmail.com> <b6c5339f0811100851t1fd9a180pfe24312081885467@mail.gmail.com>
In-Reply-To: <b6c5339f0811100851t1fd9a180pfe24312081885467@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Copeland wrote:
> On Fri, Nov 7, 2008 at 10:26 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
>> ** 2 - wireless: not to mention the fact that ath5k wasn't installed by
>> default in ubuntu...
>> wireless more or less works, but kernel log is full of backtraces.
> 
> As you've seen, these should at least be gone now...
> 
>> Was able to connect to my WPA2 access point.
>> Sometimes wireless fails completely, especially after suspend to ram.
> 
> Did you get noise calibration failures in dmesg at this point?  Felix posted
> a patch recently that handles them better.
Yep, but they seems to be gone in latest -git too.
Wireless work fine now, it seems like my iwl3945.

> 
>> Advanced features like monitor/injection work, but when I changed the card's
>> mac address it stopped working.
>> I also noticed that if I then start airodump, then wireless works with new
>> mac.
Why it doesn't accept new mac?, can this be fixed?


> 
>> ** 4 - wireless led doesn't work.
>> ath5k devs, can you fix this?
> 
> Currently all the LED code we have in there is for setting a particular gpio
> for particular laptops (and they differ between models).  We only have quirks
> for IBM and HP, none for Acer.  Also, the legacy-hal seems to have a different
> strategy for 2425 chips.  I can try to hack up some code for you to test.
> 

I have seen on the web that madwifi did support the led with some gpio settings

sysctl -w dev.wifi0.ledpin=3
sysctl -w dev.wifi0.softled=1

from https://help.ubuntu.com/community/AspireOne

Best regards,
	Maxim Levitsky
