Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbXEODDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbXEODDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 23:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbXEODDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 23:03:00 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:4347 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbXEODC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 23:02:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gtMKcfQ0Ga9z19c915lja9UcSK4Oxfl+Y7Sco2Gb8BL75KdTPbNfttY0WgbJPpbXxFmHJRwl/VM5izZBOYzgPxVpNWm//PAtncbj6VHUc59x7xmolDWmj3UAFbYKxxy2MRqlAqnMJUrp/JJoFNVVrYceZnB0IehtOmfsOyi9Sqg=
Message-ID: <a781481a0705142002g41312a03nc462fffd0a74310b@mail.gmail.com>
Date: Tue, 15 May 2007 08:32:57 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: Linux 2.6.22-rc1
Cc: "Tilman Schmidt" <tilman@imap.cc>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4648DE37.2080505@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	 <4647569D.7010709@imap.cc>
	 <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr>
	 <4648A3DF.7040004@imap.cc>
	 <Pine.LNX.4.61.0705142227350.9570@yvahk01.tjqt.qr>
	 <4648D74C.6010305@imap.cc> <4648DE37.2080505@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Tilman Schmidt wrote:
> > Am 14.05.2007 22:33 schrieb Jan Engelhardt:
> >>   * Disabling this menu disables all the fluff inside it,
>
> except when it doesn't.
>
> > Another essential piece of information. I seem to remember other
> > menus which, when disabled, kept the selection status of the
> > options inside and just hid them from view.
>
> It's a matter of /dependence/ on a menuconfig option whether options
> inside the menu will be disabled.  Not a matter of being located in the
> menu.

Yeah, this is a good solution -- making options inside a menuconfig
also dependent on it makes sense.

> If menuconfig isn't used with strict discipline, we end up with
> inconsistent and misleading presentation of the kernel configuration.

Yes, this really requires discipline on the part of those who add new
config options, to also "depends on" the menuconfig they're inside,
otherwise we end up with inconsistencies. We can't really make this
automatic, or can we?
