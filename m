Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbYEIABC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbYEIABC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 20:01:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYEIAAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 20:00:52 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:7740 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbYEIAAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 20:00:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HJvUjvsVk90JwcvW2ONXqwlAMzvZYTwrJXahgR5gyv3jBCNpfoyNI0y9lF5qYGJXbUdcqqiPTZOS25M9NHF8jFIK7qPkd1ABj9CZi/Fmund7tuJNaT2XxGzV+dJPguSauLQ9yfaMKatBHyS3nRfr2Bw1j7+WI8co6u/H7OSpHWs=
Message-ID: <dd18b0c30805081700s474f8055u7274ea5adb44cd24@mail.gmail.com>
Date: Fri, 9 May 2008 00:00:49 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "James Cloos" <cloos@jhcloos.com>
Subject: Re: Regression: starting X locks box with git master
Cc: linux-kernel@vger.kernel.org, "Rafael J Wysocki" <rjw@sisk.pl>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
In-Reply-To: <m3tzh8bdz9.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <m3hcdrqb03.fsf@lugabout.jhcloos.org>
	 <86802c440804241352v2623222bt28129a2c501cff25@mail.gmail.com>
	 <m37iemq3qa.fsf@lugabout.jhcloos.org> <200805072353.02085.rjw@sisk.pl>
	 <m3tzh8bdz9.fsf@lugabout.jhcloos.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2008 at 10:57 PM, James Cloos <cloos@jhcloos.com> wrote:
> Git master as of 3de2403e allows me to run X again.
>
> After installing the new kernel I also re-compiled all of the X server
> stack (libdrm, libpciaccess, mesa, the X server and the video driver).
> I don't know how much of a difference that made.
>
> I don't know whether the problem was sched, x86, agp or dri related,
> but AFAICT it is now fixed.
>
> Thanks,
>
> -JimC
> --
> James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
>

Well; After reverting to 2.6.25-rc* then contemplating(beer) for a
while I decided to pull the latest git today, the problem now was with
atapiix, So with that in mind I decided to load 2.6.26-rc1 everything
seems to be O.K., the problem I have is: I receive a blank screen when
I load fglrx,
then startx. I think it has to do with /proc/mtrr and pat almost as if
I'm on the wrong screen. With that said I wouldn't be such a pain
about wanting fglrx, hell I don't even play video games, well a long
time ago at least(Myst, Riven, schism)or use 3D applications, but this
module was the only module that was at least working with the suspend
mechanism, This way  I can test X11 and see if appletouch can survive,
scroll function on the mighty mouse can survive,and DVD playback can
survive properly after a wake-up. With that in mind has anybody gotten
suspend to work with radeonhd, or any other module for the macbook
pro. That way I can at least have that function working,and out of the
way, so I can move on to other things, besides having my eyes go
crosseyed trying to find code that isn't there.
Anyways I'll let you know if I come upon anything interesting;
regards;


-- 
Justin P. Mattock
