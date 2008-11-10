Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbYKJWMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbYKJWMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 17:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbYKJWMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 17:12:17 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:10943 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYKJWMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 17:12:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DrfzHfk7nvS5Je+aTKi3KNzWXcH8GX4uYiJQkuzUM30aFEHGGG4qs/ZpLCsEdwGB73
         FfhXXZPqclnbxW03o7YFWiUe5MShDW98mVTNXgI5dUX0v2JxkOLLiPiFOWNJpI0XWp6N
         wUfHdI/T8/wuda4ZzNFBGqn3LB8hgxYFlzXLg=
Message-ID: <40f31dec0811101412n1a4faf86sf4b1f37bb41caef9@mail.gmail.com>
Date: Tue, 11 Nov 2008 00:12:14 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Maxim Levitsky" <maximlevitsky@gmail.com>
Subject: Re: [ath5k-devel] Bugs on aspire one A150
Cc: "Bob Copeland" <me@bobcopeland.com>, linux-pm@lists.linux-foundation.org,
       ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
In-Reply-To: <4918A8C5.3050607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491506DB.1070000@gmail.com>
	 <b6c5339f0811100851t1fd9a180pfe24312081885467@mail.gmail.com>
	 <4918A8C5.3050607@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/10 Maxim Levitsky <maximlevitsky@gmail.com>:
> Bob Copeland wrote:
>> On Fri, Nov 7, 2008 at 10:26 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
>>> ** 2 - wireless: not to mention the fact that ath5k wasn't installed by
>>> default in ubuntu...
>>> wireless more or less works, but kernel log is full of backtraces.
>>
>> As you've seen, these should at least be gone now...
>>
>>> Was able to connect to my WPA2 access point.
>>> Sometimes wireless fails completely, especially after suspend to ram.
>>
>> Did you get noise calibration failures in dmesg at this point?  Felix posted
>> a patch recently that handles them better.
> Yep, but they seems to be gone in latest -git too.
> Wireless work fine now, it seems like my iwl3945.
>
>>
>>> Advanced features like monitor/injection work, but when I changed the card's
>>> mac address it stopped working.
>>> I also noticed that if I then start airodump, then wireless works with new
>>> mac.
> Why it doesn't accept new mac?, can this be fixed?
>
>
>>
>>> ** 4 - wireless led doesn't work.
>>> ath5k devs, can you fix this?
>>
>> Currently all the LED code we have in there is for setting a particular gpio
>> for particular laptops (and they differ between models).  We only have quirks
>> for IBM and HP, none for Acer.  Also, the legacy-hal seems to have a different
>> strategy for 2425 chips.  I can try to hack up some code for you to test.
>>
>
> I have seen on the web that madwifi did support the led with some gpio settings
>
> sysctl -w dev.wifi0.ledpin=3
> sysctl -w dev.wifi0.softled=1
>
> from https://help.ubuntu.com/community/AspireOne
>
> Best regards,
>        Maxim Levitsky

i think that some led settings are stored on EEPROM, let me check it out...


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
