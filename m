Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbZF3ShO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbZF3ShO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 14:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbZF3ShE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 14:37:04 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:61517 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbZF3ShD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 14:37:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UvpxOpZ2M/j4iEbr7kICeYhYfaGIFs7v9q9mo5zza1/Ue4ZIKDD9hdK1jeJbllduKC
         vFPksO8GYrYZm88GNcDA0VKU4GqPyWXgqgg9WOJBINvYzXALcGdRjxSPYfNwMc/LoJA/
         TVN9j7G/YMywtk5fE3O50DhsEqndeO8+t9M+w=
Message-ID: <4A4A5B93.3070302@gmail.com>
Date: Tue, 30 Jun 2009 11:38:11 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: need help figuring out what makes my wireless"iwconfig" not respond
References: <4A499531.4040001@gmail.com> <4A49980E.2010405@lwfinger.net>
In-Reply-To: <4A49980E.2010405@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> Justin P. Mattock wrote:
>    
>> from 2.6.31-rc1 to present there was a couple of commits for
>> wireless. prior to that the wireless on my machine(imac)
>> was o.k.,
>> Now the wireless does work(streams music,t.v. etc..)
>> but when I look at iwconfig there's nothing no info.
>> (I use wicd as my connection manager, and in the bottom corner
>> of the screen the transmit power is down to almost nothing,
>> causing wicd to constantly reconnect)
>>
>> out of a random guess what commit might have caused this, so I can at least
>> fix this over here(that is until the manufacturer comes out with a new
>> version). I can go in and individually revert all of the wireless, but
>> before that
>> I want a quick lead.
>>
>> any ideas?
>>
>>      
>
> If you have a git tree, use the "git bisect" commands to find the bad
> commit.
>
>    
Well, I did the git bisect start routine,
but realized, this takes longer than expected,
so being easier for myself going the the web interface with firefox
seems better.
But after looking through all of the changes through
mac80211, and reverting most of them, and having my machine
scarcely not boot, as well as osx, I decided (f^*k this s^*t)
I'll just leave my machine(imac) with the kernel that runs nicely.

But positive side with all of the changes to mac80211, my macbook
is running all of that just fine(seems to be running a little hotter,
but that just might be the outside temp doing this).

Thanks for the reply,
(I'll just be patient until the later).

Justin P. Mattock
