Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbZELTQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbZELTQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 15:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZELTQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 15:16:45 -0400
Received: from blaine.gmane.org ([80.91.229.8]:35624 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbZELTQo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 15:16:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LvAh6372vDYNgx6ie0d8qQ/IcOTAaHjPae5wxHk38WQnFYHcEc9c9fUIGl+F3/DO8L
         ebceIVi4UuvWqTKVEgrX7uNaS7Xcj/PuN09HQik9EJsgtBRHnA4hCJJ3sWDoKl1mr6L9
         Xf2co5scbtqLkBkAWr7+bd67fQ/PrlGLrmUUw=
MIME-Version: 1.0
In-Reply-To: <20090512103905.0D68E1FD10@chi.die-welt.net>
References: <dd18b0c30905111002y4aeb2033ma2fbb2730f5acdaf@mail.gmail.com>
	 <4A089E49.7080403@gmail.com>
	 <20090512103905.0D68E1FD10@chi.die-welt.net>
Date: Tue, 12 May 2009 07:28:04 -0700
Message-ID: <dd18b0c30905120728v156d4e1g808a853d23ba0ae6@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
X-TMDA-Confirmed: Tue, 12 May 2009 19:39:17 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Tue, May 12, 2009 at 3:39 AM, Evgeni Golov <sargentd@die-welt.net> wrote:
>
>
> On Mon, 11 May 2009 23:53:13 +0200 Jiri Slaby wrote:
>
>> > in dmesg I see:
>> >
>> > [   36.337419] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 1
>> > [   36.530106] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 2
>> > [   36.730100] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 3
>> > [   36.930101] wlan0: direct probe to AP 00:1e:2a:00:67:f0 timed out
>> > [   44.421728] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 1
>> > [   44.620080] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 2
>> > [   44.820080] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 3
>> > [   45.020076] wlan0: direct probe to AP 00:1e:2a:00:67:f0 timed out
>> >
>> > The type of encryption used is just
>> > a standard WEP key(no WPA).
>
> Same here with 2.6.30-rc4, b43 and either Cisco (MAC-Addr starts with
> 00:40:96) or HP ProCurve (??? - they do WiFi? - MAC-Addr starts with
> 00:1F:FE) APs. No encryption, quite noisy environment (University).
>
> No problem with ipw2200 (actually 2915) in the same hardware (Thinkpad
> X31). Neither with the b43 and a standard Linksys WRT54GL (in the same!
> noisy university-env).
>
> Regards
> Evgeni
>
>

are you able to connect?
(or is the connection connecting but really
poor quality?)
over here 2.6.29-rc8 connects like
theirs no tomorrow, as soon as
I throw in 2.6.30-rc4 it just dead(although
on some accounts I did get some kind of
reaction, but not much, just what I see in dmesg).

-- 
Justin P. Mattock


