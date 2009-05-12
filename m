Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbZELXrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbZELXrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbZELXrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:47:42 -0400
Received: from blaine.gmane.org ([80.91.229.8]:56615 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbZELXrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:47:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=tLVN0188UcR0108J24ceDXa+m27XICh0cgXTwbJxJsPl9PVUPulslu4QGW5WyqqZw7
         zavfXNmGu7BYcaIQAgTeKZNDYTtcCZRXvgLm0ut41/hecg8Cpz76+oxm3du7AlzCqdvS
         nD/IpuYctYBudkKzT4NDtUZRXELzyrdnxSHTg=
MIME-Version: 1.0
In-Reply-To: <dd18b0c30905121304k6df44362v76e8e7ae6da3b76f@mail.gmail.com>
References: <dd18b0c30905111002y4aeb2033ma2fbb2730f5acdaf@mail.gmail.com> 
	<4A089E49.7080403@gmail.com> <20090512103905.0D68E1FD10@chi.die-welt.net> 
	<dd18b0c30905120728v156d4e1g808a853d23ba0ae6@mail.gmail.com> 
	<20090512174636.8EBDA1FD10@chi.die-welt.net> <dd18b0c30905121304k6df44362v76e8e7ae6da3b76f@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 12 May 2009 16:01:07 -0700
Message-ID: <43e72e890905121601y59de3d3fh9eca4637883c37fa@mail.gmail.com>
Subject: Re: ath9k seems to be broken on 2.6.30-rc4 with a macbook pro
To: Justin Mattock <justinmattock@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>
Cc: Evgeni Golov <sargentd@die-welt.net>,
       Jiri Slaby 
	<public-jirislaby-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>,
       Justin Mattock 
	<public-justinmattock-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>,
       Linux Kernel Mailing List 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       public-ath9k-devel-xDcbHBWguxHbcTqmT+pZeQ@hugh.gmane.org,
       public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, May 12, 2009 at 1:04 PM, Justin Mattock <justinmattock@gmail.com> wrote:
>
>
> On Tue, May 12, 2009 at 10:46 AM, Evgeni Golov <sargentd@die-welt.net> wrote:
>> On Tue, 12 May 2009 07:28:04 -0700 Justin Mattock wrote:
>>
>>> > Same here with 2.6.30-rc4, b43 and either Cisco (MAC-Addr starts with
>>> > 00:40:96) or HP ProCurve (??? - they do WiFi? - MAC-Addr starts with
>>> > 00:1F:FE) APs. No encryption, quite noisy environment (University).
>>> >
>>> > No problem with ipw2200 (actually 2915) in the same hardware (Thinkpad
>>> > X31). Neither with the b43 and a standard Linksys WRT54GL (in the same!
>>> > noisy university-env).
>>> >
>>> > Regards
>>> > Evgeni
>>> >
>>> >
>>>
>>> are you able to connect?
>>> (or is the connection connecting but really
>>> poor quality?)
>>> over here 2.6.29-rc8 connects like
>>> theirs no tomorrow, as soon as
>>> I throw in 2.6.30-rc4 it just dead(although
>>> on some accounts I did get some kind of
>>> reaction, but not much, just what I see in dmesg).
>>
>> 2.6.29: fairly stable, even if not as good as with an intel card.
>> 2.6.30-rc4: tons of timeouts, may connect 1 in 100 tries, connection
>> will drop after some (short) time.
>>
>> --
>> Bruce Schneier Fact Number 79:
>> Bruce Schneier once decrypted a box of AlphaBits.
>>
>
> O.K. after trial and error reverting this:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=47afbaf5af9454a7a1a64591e20cbfcc27ca67a8;hp=853da11b94e674445e93660f47a5f0aeeea09623
>
> brings life back to the macbook with 2.6.30-rc4
> (not sure about the iphone anomaly though, I'll keep
> an eye on that)

Odd.. are you changing TX power through wext? Because that 47afbaf5
should only make a difference when using manual tx power setting.

  Luis

