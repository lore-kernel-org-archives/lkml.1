Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbYLNWaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbYLNWaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 17:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbYLNW3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 17:29:52 -0500
Received: from mail-gx0-f12.google.com ([209.85.217.12]:47946 "EHLO
	mail-gx0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbYLNW3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 17:29:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kioAYSOzVUXmr0+wfitIsIqmfTMEwFrxxpToAkeD9rwFHktg7LegWyCekQPfyzotCU
         hyyFXDOn86RLRPm3PkUxd1d/N/zXQPwP/I5s64QVoY4gWsGMP7BzD6SnTwEw+nDLgoLf
         ApVKNxARx5QDeb7LYfPDRbyAcxT2yBQyVUEFM=
Message-ID: <494588DA.6040801@gmail.com>
Date: Sun, 14 Dec 2008 14:29:46 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: suspend/resume fails on second attempt in LNXVIDEO:00
References: <gi247o$iog$1@ger.gmane.org> <4944AAFD.1060105@gmail.com> <gi3rsp$iog$2@ger.gmane.org>
In-Reply-To: <gi3rsp$iog$2@ger.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian J. Murrell wrote:
> On Sat, 13 Dec 2008 22:43:09 -0800, Justin P. Mattock wrote:
>
>   
>> not too sure what the situation is for you, but if  you're deciding to
>> stay with 2.6.24.* then look through the commits to see if this has been
>> resolved. if not then load the latest git to see if this has been
>> committed for the fix.
>>     
>
> Well, I've just built and installed 2.6.28-rc8 and the problem persists.
>
>   
>> if it's just debugging then hmm.. maybe ssh (but
>> you don't have intranet upon wakeup);
>>     
>
> Right.  It's for all intents and purposes "dead" on resume.  Even 
> CAPSLOCK on the console does not active the LED.
>
>   
>> maybe usb or some other hard wired
>> mechanism?
>>     
>
> I'd hoped to do serial console, but sadly, this laptop, like many today 
> doesn't have even a single serial port.  I had considered a USB serial 
> and making it console (if even possible) but now I am just spending more 
> money trying to get this stupid laptop working.  ~sigh~
>
> b.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   
 From over here with a macbook(no serial port as well)
making debugging intricate to the extent.
With running radeon it's weired,
 if I do an echo mem > /sys/power/state
upon wakeup I'll have a black screen,(intranet works)
but if I do a  s2ram "poof" like magic it works.
if using (sorry for the word) fglrx, echo mem
works. haven't tried s2ram with that though.
Aside note glad to see you're running the latest kernel.
for the past week or so there was posts about suspend
but haven't kept up(was busy looking at SELinux refpolicy UBAC)
maybe there was some talks or even some patches submitted
for what you're dealing with?

regards;

Justin P. Mattock

