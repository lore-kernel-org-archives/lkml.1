Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbYDHMwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbYDHMwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 08:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbYDHMwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 08:52:41 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:16381 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbYDHMwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 08:52:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VvQH581ujqgIpi6Y3Q1Lg+T4YEpTwO6QYUu41e+7wMtcmTPXUwh/X2d5Qp8CwUVW0amd4NhavVpbrNCshYrvPruVVw+A9wom1sL5wg/0u+K8tBFKdN2y2/xMTJ5nlnKuVWAmwti9/wXDh77so6lBXNKphpfhdfB46hDauoUZ0tA=
Message-ID: <b637ec0b0804080552i1a6b5ddg5bbba0324da4e14e@mail.gmail.com>
Date: Tue, 8 Apr 2008 14:52:38 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Soeren Sonnenburg" <kernel@nn7.de>
Subject: Re: 2.6.25-rc6 regression - hang on resume [Bug 10319]
Cc: "Romano Giannetti" <romanol@upcomillas.es>,
       "Tino Keitel" <tino.keitel@gmx.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       suspend-devel@lists.sourceforge.net
In-Reply-To: <1207658383.553.17.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
	 <1207290689.4511.1.camel@localhost> <1207552602.26185.13.camel@pern>
	 <200804071110.39933.rjw@sisk.pl>
	 <20080408085846.GA15403@dose.home.local>
	 <1207658107.21698.17.camel@pern> <1207658383.553.17.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2008 at 2:39 PM, Soeren Sonnenburg <kernel@nn7.de> wrote:
> On Tue, 2008-04-08 at 14:35 +0200, Romano Giannetti wrote:
>  >
>  > On Tue, 2008-04-08 at 10:58 +0200, Tino Keitel wrote:
>  > > With 2.6.25-rc, the text console is fine after resume, due to the
>  > > recent changes to the Intel i915 DRM driver. Maybe those people who
>  > > used to use vbetool prior to 2.6.25 should check if this is still
>  > > needed.
>  >
>  > Yep, the problem is just that: in 2.6.24 vbetool hacks (in my case,
>  > using s2ram -p -m options) was needed to resume graphics. Now they are
>  > not needed anymore, and using them _break_ resume.
>  >
>  > So, people with a working suspend-to-ram setup (even using the whitelist
>  > in s2ram, I mean, simply calling s2ram) will discover that 2.6.25 break
>  > their machine. Removing the s2ram package and suspending with
>  > kernel-only machinery will work, but... well, it's not user-friendly.
>
>  The above holds only if you have an intel graphics adapter. For me
>  (radeon) it really breaks (as in echo mem >/sys/power/state leaves me a
>  black screen on resume and manually typing vbetool post or vbetool
>  vgamode simply hangs the machine).
>

For me (radeon X700) using binary fglrx xorg driver without the binary
kernel module (which does not compile under .25rc for me)
resume-from-ram works using s2ram.

Lightly tested with -rc8.

My laptop is in whitelist as VBE_POST|VBE_SAVE|NOFB .

>  Soeren

Fabio
