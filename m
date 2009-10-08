Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbZJHBuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbZJHBuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 21:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbZJHBuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 21:50:18 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:54161 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbZJHBuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 21:50:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=JgqeovZhpixF+91eD16/bH2tk3BMfNlx7wjI1SZURhIVaPNNwzlUquCB90tK6U1YPz
         NOEtg3CEFOGUR4M48fdBqPxwTdeCblteQOLfTi53H9B2iSNfI0mBo88qxBRSPeJEh9kf
         uKaPjWChnvf3BBcjxOjDUWt+1DqND87IjzyJA=
Message-ID: <4ACD4547.2000306@gmail.com>
Date: Wed, 07 Oct 2009 18:49:59 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Tim Walberg <twalberg@comcast.net>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-wireless@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Disassociating atheros wlan with 2.6.31
References: <20090924121617.c0c7222d.kristoffer.ericson@gmail.com> <4ABBB9D3.4020200@gmail.com> <200909242155.49890.s.L-H@gmx.de> <4ABBD170.6060702@gmail.com> <20091004174535.777d233c.kristoffer.ericson@gmail.com> <20091008011247.GC22458@comcast.net>
In-Reply-To: <20091008011247.GC22458@comcast.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Walberg wrote:
> Another confirmed instance of this on ath9k - on 2.6.31.2 and 2.6.31.3 - didn't
> happen on 2.6.30.6 or 2.6.30.9. A couple other interesting facts:
>
> - it seems to be related (at least in my case) to heavy transmit load -
>    I can download a kernel tarball without it failing, but if I try to
>    copy it to another system, it fails within 2 seconds reliably...
> - running 'rmmod ath9k ath mac80211 cfg80211' followed by 'modprobe ath9k'
>    clears it up
>
> No indication in dmesg except:
>
> 	wlan<n>: no probe response from AP AA:BB:DD:EE:FF:GG - disassociating
>
> and suddenly no packets going in either direction.
>
> I'm in the process of moving back to 2.6.30.x for now...
>
>
>
>
>
> On 10/04/2009 17:45 +0200, Kristoffer Ericson wrote:
>    
>
>    
I get this reliably by simple running a radio station
through mplayer(probably around 5/10 min of running)
when I run this commit:
2.6.31-rc8-00039-g03c3bbc I don't have this at all.
(I might of changed my .config without realizing it)

After running a bisect from this commit to current
I came up with nothing, which led me to believe that I must have through
the confusion changed something in my .config, or messed up
with choosing good/bad with the bisect because I didn't wait long enough for
this to fire off.

In any case either/or I'm still going to give a go at the bisect again
but this time wait longer(10/20 min) to really make sure I don't miss
anything.

BTW: when this hits for you is it pretty bad(no connection) i.g when 
this fires off over here
music still plays from mplayer, but did notice that mplayer player all 
of a sudden would die out, but
easily connected again.

Justin P. Mattock
