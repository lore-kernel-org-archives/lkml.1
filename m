Return-Path: <linux-kernel-owner+w=401wt.eu-S1757129AbYCWWWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbYCWWWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 18:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbYCWWWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 18:22:08 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:42829 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbYCWWWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 18:22:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=E+KELHzWVn5jVr0+59OhznvRSelIibdDl14y56TwuQVdgVxtpUIDFghjnGKJ9/L4l83P3FY0V3j2vCg5dDlkH/DXfg31ZwVJodIz+GhApZBfjzA7f3SuaMOfi0NdCJcCraED1dGdkzNWL09u/QMdE1MO29JSH/FnP/obbwdz1vk=
Message-ID: <2c0942db0803231522w7c66f168xf7fea72d135ba395@mail.gmail.com>
Date: Sun, 23 Mar 2008 15:22:02 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: Kai <epimetreus@fastmail.fm>
Subject: Re: Serious performance regression in Wine applications and Linux 2.6.24.*
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1206310206.17373.1243881033@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206310206.17373.1243881033@webmail.messagingengine.com>
X-Google-Sender-Auth: ef0d5078de53caf6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please don't top post. If we figure out who to CC: who knows more
about this than I do -- which wouldn't be hard -- then they're going
to want to see all this in order. Also, please always do a
reply-to-all on this list, it's preferred.)

On Sun, Mar 23, 2008 at 3:10 PM, Kai <epimetreus@fastmail.fm> wrote:
> > Kai wrote:
>  > > Performance degrades by about 60% when I run Wine under any of the
>  > > 2.6.24.* kernels. Attached are the output of lspci -vv and the two
>  > > config files of each kernel.
>  > >
>  > > I upgraded to 2.6.24, back to 2.6.23.(not sure), then tried 2.6.24.1 and
>  > > 2.6.24.3 and the issue is present in both; it's severe enough that Wine
>  > > apps are virtually unusable for me with this version of the kernel; I'm
>  > > having to use 2.6.23 until this somehow is resolved.
>  > >
>  > > I'd like some help figuring out why this performance regression exists,
>  > > and what can be done to mitigate it.
>  > >
>  > > Please CC replies; I'm not on the list.
>  > >
>  > This is strange, as my (two) Windows apps ran (and run) just fine under
>  > 2.6.24 (and now under 2.6.25-rc6). Could you specify the applications
>  > you're having problems with?
>
> Originally, it was just about everything -- Wine itself, and most any
>  app I tried to run with it.
>
>  In my most recent tests, however, it only seems to affect Age of Wonders
>  II and Age of Wonders Shadow Magic, which use very similar engines.

What version of X? What version of WINE? Which video driver are you
using? Does the speed issue show up with glxgears, or something else
that would be much easier for someone else to reproduce (tuxracer,
etc.)? Is your system using software or hardware rendering?
