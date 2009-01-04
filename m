Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbZADE31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbZADE31 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 23:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbZADE3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 23:29:17 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:23354 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbZADE3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 23:29:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sZFi9qqE5M5uxPZ9148yQHvx3qN8es8UzZwyVoq+1JbXT0iZDBw/ZFuSCff+svh/0x
         foEmsKNM8oXvq3vRy3sC7E1tElxYv3/Dh2MigLMClWXVcdSUfG84p06ZWMejft9fa7it
         nfe13ibjm8iPqJ+M4ktMbSUdo6+A4uWhlkpjo=
Message-ID: <49603B15.9080701@gmail.com>
Date: Sat, 03 Jan 2009 20:29:09 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081126)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Daniel Phillips <phillips@phunq.net>, tux3@tux3.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: A Golden Copy
References: <200812301935.49303.phillips@phunq.net> <200901021719.26680.phillips@phunq.net> <495EC040.2070905@gmail.com> <200901021903.24189.phillips@phunq.net> <495EDE04.5080703@gmail.com> <20090104031733.GB20929@shareable.org>
In-Reply-To: <20090104031733.GB20929@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> Justin P. Mattock wrote:
>   
>> Thats some crazy stuff!! and just think most of it is
>> simply magnets.(but more complicated than that)
>>     
>>> One feature we are kicking around to make life easier for SELinux:
>>> sometimes the filesystem can run while SELinux is not running, and
>>> security labels will be wrong when SELinux re-enters the picture.  We
>>> have in mind to provide a persistent log of filesystem events that the
>>> security system can attach to on startup and find out what went on in
>>> its absence.
>>>
>>>  
>>>       
>> That sounds nice:
>>
>> find out what went on in
>> its absence.
>>     
>
> That sounds like a feature Windows had for many years now, (since
> Windows 2000?).  It complements the Windows equivlant of
> dnotify/inotify/fsnotify.
>
> It's used for file indexing too (think equivalent to Spotlight,
> Beagle, etc.), and other types of security scanning (think equivalent
> to Tripwire).
>
> I wonder why the people writing file indexing tools for Linux never
> made a fuss about this.  Inotify is ok for indexing, but means quite a
> few minutes of intensive disk activity after each boot to rescan /home.
>
> -- Jamie
>
>   
Thanks for the info.
What about apps like git?
i.g. when changing a file
it knows that the file was changed;
(not sure how it works, remembers
 the size or something like that);

With the file indexing is it smart(like git) enough
to know that the data was changed, or does it just
go by the name.  With running SELinux I'm able to
change wpa_supplicant.conf with different ssid's
and keys and there wont be a denial, but If I change
out libflashplayer.so with a newer or same plugin
I will receive a denial. (bad example but all I could think of)
So it does have an idea to when a file is changed.
personally having mechanisms know exactly when
a file was changed internally is nice, this way
you at least are aware
that something has changed, and you know where.

regards;

Justin P. Mattock
