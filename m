Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbXLNSpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbXLNSpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbXLNSpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:45:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:63700 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbXLNSpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:45:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fGKe4CmAU5PVVeWI+pVXIlL7d5rSRiMkfb44os8w6jYVAR6QaxNO5jc30LPCupFxPkQyfzZ83VbadBvUic6UxmPYCvHRv8/ABC/CXFMAACXf7PF3doVDvKrZ1NFc5nA/iNDJjm282h3MvNHfDkUqDc/7yBOQShufsaNeHKv+vAg=
Message-ID: <2c0942db0712141045nf7bf730l677936614f7db736@mail.gmail.com>
Date: Fri, 14 Dec 2007 10:45:02 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Cc: "Ingo Molnar" <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
       "Daniel Walker" <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com,
       "John Linville" <linville@tuxdriver.com>,
       "Larry Finger" <Larry.Finger@lwfinger.net>
In-Reply-To: <200712141922.04677.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <200712141749.33708.mb@bu3sch.de>
	 <2c0942db0712141001l6ad77657q1dceee5cb872a979@mail.gmail.com>
	 <200712141922.04677.mb@bu3sch.de>
X-Google-Sender-Auth: ba990f9b548d3baa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've run out of time to donate to the kernel today, so I'll keep this short.

On Dec 14, 2007 10:22 AM, Michael Buesch <mb@bu3sch.de> wrote:
> > > If you have a PCI device probing works as follows:
> > > The PCI table is in ssb. So as soon as your kernel detects the PCI device
> > > it will load ssb. ssb will register the PCI device. That will trigger
> > > an udev event for the contained 802.11 core to get probed. This will load
> > > b43.
> > >
> > > So, I'm not sure where's the issue with my code here.
> >
> > There's a patch from Larry Finger to address this and other issues. It
> > hasn't made it's way fully upstream yet. Please read your message
> > here, in particular item number seven on Larry's list:
> >
> > https://lists.berlios.de/pipermail/bcm43xx-dev/2007-December/006472.html
>
> 1) I sent this patch out today for inclusion in the kernel
> 2) This is a _completely_ unrelated issue.
>    It is about "rfkill-input" being not loaded. NOT about
>    "b43" or "rfkill" not being loaded.
[...]
> > So, do you want a scorecard on this?
> >
> > One problem related to b43 source code, patch exists, has yet to be
> > merged upstream.
>
> Yeah. A problem preventing a LED from blinking.
> That's a real regression.... Come on. Stop that bullshit.

I'm going to say this one last time. If rfkill and rfkill-input aren't
manually loaded before sb and b43, not one damn thing comes out in
dmesg. Nothing. Nada. Zilch. Zero. Bupkis. Zot. Null. The only way to
find out that those modules had to be loaded by hand was to go read
the bcm43xx-dev archives. Once those were loaded, messages came out in
dmesg pointing me to the URL for updated firmware.

I have complete current userspace as of yesterday's Ubuntu Hardy Heron
development archives.

One last thing. I've been nice to you. Please be nice to me. If you
can't manage that, then let another wireless developer take over.

You apparently think I'm an idiot. I'm not, and if necessary I could
supply a long list of credentials to prove I'm not an idiot. I'd
rather you just accepted my emails at face value and spent more effort
on trying to see how the bugs could be occurring rather than spending
effort on trying to prove that I'm an idiot.

Thanks.

Ray
