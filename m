Return-Path: <linux-kernel-owner+w=401wt.eu-S1161080AbXAZSDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161080AbXAZSDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161111AbXAZSDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:03:43 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:55752 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161080AbXAZSDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:03:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jBXPRucDObSTg3VSPaNeT/spuFtTalRNL7S7zgfXccaEsTd3D/YrbXWtcpcmEAiWYxNKj6VYId8H/Ug6EGYwIXpdrjiaO5NluL96aFob7GFwyym18ZANTc6YxgWCgRGlpZLAHokLgPm4JqdD14jNpTSSaFdSJNmBlCMa2jq1kPw=
Message-ID: <806dafc20701261003s1790ada8xbec94c914424c86f@mail.gmail.com>
Date: Fri, 26 Jan 2007 13:03:41 -0500
From: xiphmont@xiph.org
To: "Greg KH" <greg@kroah.com>
Subject: Re: [Alsa-devel] [PATCH] alsa: correct nonsensical sysfs device symlinks
Cc: "Takashi Iwai" <tiwai@suse.de>, "Pierre Ossman" <drzeus@drzeus.cx>,
       fedora-desktop-list@redhat.com, alsa-devel@alsa-project.org,
       jrb@redhat.com, linux-kernel@vger.kernel.org, mclasen@redhat.com,
       "Lennart Poettering" <lennart@poettering.net>, perex@suse.cz
In-Reply-To: <20070125215943.GC3126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <806dafc20701250903p6b67d176wf00dd2a9d92d899f@mail.gmail.com>
	 <s5h7ivbuhg1.wl%tiwai@suse.de>
	 <806dafc20701251007n69bc9b3cse023b51369501d42@mail.gmail.com>
	 <s5h4pqfufs8.wl%tiwai@suse.de>
	 <806dafc20701251034l59fc5be7ta881606046eb819a@mail.gmail.com>
	 <s5h1wljuf2f.wl%tiwai@suse.de>
	 <806dafc20701251051p2750cb34sab88a38282020497@mail.gmail.com>
	 <20070125194933.GA27857@kroah.com>
	 <806dafc20701251240t70335055l74c47ecdd09d1944@mail.gmail.com>
	 <20070125215943.GC3126@kroah.com>
X-Google-Sender-Auth: 4761d23a4318b5b9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Before I get to the less focused rant below, I wanted to mention that
the HELP text for 'Create deprecated sysfs files' does not make it
clear that one is opting for old in exclusion of new.

On 1/25/07, Greg KH <greg@kroah.com> wrote:

> There is no such thing as a "stable release update" series anymore, you
> should know that :)

To the detriment of the users, yes.  Subminor release update and
*bam*, audio doesn't work and it takes a kernel hacker to figure out
why, and because of a small but inevitable error (error is inevitable
in change). If this was a Windows service pack or a MacOS subminor
update, it would be front page news in industry trade mags.  The fact
that it isn't is because it's Linux and we're frankly still the
retarded foster child adopted for tax purposes, at least as far as the
desktop goes.

I'm not saying change is bad, I'm saying this was a subtle, large
change and no one has explained the functional benefit beyond 'it's
cleaner' to outweigh 'many users want to strangle us'.

> Well, as this HALD issue is the only thing that I have had reported, and
> these patches have been in the -mm tree for quite some time, yes, I
> think it is the only thing that has broken.

Plenty of people spotted it, several bugs got filed, and the fact that
you're only hearing about it from me at least two months after
introduction is mildly worrisome.  (I am already worried that *I*
didn't hear about it till recently as I attempted to push out Pulse in
fc rawhide and found it magically no longer worked.  At all.)

If the hald developers were caught unprepared (so unprepared, in fact,
they've all ben inaccessable due to holiday + conference + vacation
for over a month and we can't push an update out), what is the average
user to do?  Not to mention the fact that it's just a little
embarrassing that sysfs was invented for 2.6 and the original version
has already been declared deprecated, still in 2.6.  There's change,
and then there's churn.

> In short, it's a bug, I messed up somehow.  And I'm trying to fix it
> now, I don't think there's more that I can do, do you?

No.  I'm not pushing back against you, I'm pushing back against the
budding 'stable APIs are for boring losers' culture.  There's a reason
I refuse to update my personal machines more often than once every
year or two-- they spend the next few weeks completely dysfunctional
each time.  To be fair, the kernel is usually far better than userland
[excepting ALSA, GRRRR], but let's not go pissing away that relative
lead :-)

Monty
