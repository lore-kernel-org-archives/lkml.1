Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbZELW0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbZELW0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 18:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZELWZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 18:25:51 -0400
Received: from blaine.gmane.org ([80.91.229.8]:34952 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbZELWZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 18:25:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZngVKQx2CdoQONvNakOy9jRD9fmCGDn3U26GcyA4M8irP0RslCBGHHh2DffSy5zylk
         0z5X27HRezIj9eLZzwU4N8nQ5DWYnt2K+mJmcwhE2SRHz6OnWx3KSVJ+2HGGhcgE2AY0
         Xzhvi8cjN1Qn8FmlGV1OZMfA+zKZjFvKF1KCc=
MIME-Version: 1.0
In-Reply-To: <20090512174636.8EBDA1FD10@chi.die-welt.net>
References: <dd18b0c30905111002y4aeb2033ma2fbb2730f5acdaf@mail.gmail.com>
	 <4A089E49.7080403@gmail.com>
	 <20090512103905.0D68E1FD10@chi.die-welt.net>
	 <dd18b0c30905120728v156d4e1g808a853d23ba0ae6@mail.gmail.com>
	 <20090512174636.8EBDA1FD10@chi.die-welt.net>
Date: Tue, 12 May 2009 13:04:28 -0700
Message-ID: <dd18b0c30905121304k6df44362v76e8e7ae6da3b76f@mail.gmail.com>
Subject: Re: ath9k seems to be broken on 2.6.30-rc4 with a macbook pro
From: Justin Mattock <justinmattock@gmail.com>
To: Evgeni Golov <sargentd@die-welt.net>
Cc: Jiri Slaby 
	<public-jirislaby-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>,
       Justin Mattock 
	<public-justinmattock-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>,
       Linux Kernel Mailing List 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       public-ath9k-devel-xDcbHBWguxHbcTqmT+pZeQ@hugh.gmane.org,
       public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, May 12, 2009 at 10:46 AM, Evgeni Golov <sargentd@die-welt.net> wrote:
> On Tue, 12 May 2009 07:28:04 -0700 Justin Mattock wrote:
>
>> > Same here with 2.6.30-rc4, b43 and either Cisco (MAC-Addr starts with
>> > 00:40:96) or HP ProCurve (??? - they do WiFi? - MAC-Addr starts with
>> > 00:1F:FE) APs. No encryption, quite noisy environment (University).
>> >
>> > No problem with ipw2200 (actually 2915) in the same hardware (Thinkpad
>> > X31). Neither with the b43 and a standard Linksys WRT54GL (in the same!
>> > noisy university-env).
>> >
>> > Regards
>> > Evgeni
>> >
>> >
>>
>> are you able to connect?
>> (or is the connection connecting but really
>> poor quality?)
>> over here 2.6.29-rc8 connects like
>> theirs no tomorrow, as soon as
>> I throw in 2.6.30-rc4 it just dead(although
>> on some accounts I did get some kind of
>> reaction, but not much, just what I see in dmesg).
>
> 2.6.29: fairly stable, even if not as good as with an intel card.
> 2.6.30-rc4: tons of timeouts, may connect 1 in 100 tries, connection
> will drop after some (short) time.
>
> --
> Bruce Schneier Fact Number 79:
> Bruce Schneier once decrypted a box of AlphaBits.
>

O.K. after trial and error reverting this:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=47afbaf5af9454a7a1a64591e20cbfcc27ca67a8;hp=853da11b94e674445e93660f47a5f0aeeea09623

brings life back to the macbook with 2.6.30-rc4
(not sure about the iphone anomaly though, I'll keep
an eye on that)

-- 
Justin P. Mattock

