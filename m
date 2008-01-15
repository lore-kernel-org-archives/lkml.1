Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbYAORLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbYAORLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYAORLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:11:35 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:2804 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYAORLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:11:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aC1Q8Z6YdZflIGvwi0Z/lNzpPloiZokKdnMqHouxkwf/Z6bT81ZeP94rLMXPh9Ne9zW6jDXHAvPJYIodcTT7qj/4gdyt7zuAeMFGMemfHUiIasGyoAtp/d5D9VwcK8asus2ekHxgvezfB1QMFajgYO/L08DmpuZEMVOUtix1NrQ=
Message-ID: <e85b9d30801150911p791651e8hf0406490ad1811ee@mail.gmail.com>
Date: Tue, 15 Jan 2008 18:11:33 +0100
From: Matthew <jackdachef@gmail.com>
To: "Ingo Molnar" <mingo@redhat.com>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of 32bit applications(binaries) on 64bit system (Gentoo)
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Ed Tomlinson" <edt@aei.ca>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <200801141716.38380.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47841C41.4060401@zytor.com>
	 <e85b9d30801140847k4b19cea4nd08461c1664a1b35@mail.gmail.com>
	 <20080114170036.GL15542@elte.hu> <200801141716.38380.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ingo,
>
> This is _not_ a regression.  This has been occuring for ages here.  A backport of this fix to 2.6.23 would be a
> very good thing - IMHO its something that should go into stable asap.
>
> Thanks,
> Ed Tomlinson
>
>
>

++

Ingo,
this probably has to do something with the random unmotivated
hardlocks which I suffered from with 2.6.23

when I used 2.6.23-based kernels my rig from time to time (sometimes 2
times a day) just locked and wouldn't react to keyboard-input or magic
sysrq key anymore
if I have a more precise look at my memory (in my head) it probably
happened more often around usage with realplayer (<-- at least that
app; 32bit on amd64) [perhaps also with 32bit thunderbird]
the next suspect is nvidia-drivers: with earlier versions this
happened more often for me (that's at least the "feeling" I have)

so you guys might want to start with those 3 points (thunderbird,
realplayer, nvidia-drivers);
considerung use / test with latest cfs-backports would also be a good
idea, with early backports I had some problems, whereas it's now
perfectly stable (fair group scheduling not enabled)

unfortunately I can't / couldn't reproduce it
in addition to that I'm pretty busy right now so I can't investigate
any further ...

hope you also find the culprit for that buggy ;)

Regards
Mat
