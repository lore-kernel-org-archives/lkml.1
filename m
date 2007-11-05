Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbXKEWUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbXKEWUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 17:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbXKEWUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 17:20:33 -0500
Received: from hpsmtp-eml19.KPNXCHANGE.COM ([213.75.38.84]:14450 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752700AbXKEWUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 17:20:33 -0500
From: Frans Pop <elendil@planet.nl>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: 2.6.23: No text consoles with FRAMEBUFFER_CONSOLE_DETECT_PRIMARY
Date: Mon, 5 Nov 2007 23:20:30 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200710132013.24024.elendil@planet.nl> <1192340601.6548.11.camel@daplas>
In-Reply-To: <1192340601.6548.11.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711052320.31003.elendil@planet.nl>
X-OriginalArrivalTime: 05 Nov 2007 22:20:31.0348 (UTC) FILETIME=[13BCBB40:01C81FFA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 October 2007, Antonino A. Daplas wrote:
> On Sat, 2007-10-13 at 20:13 +0200, Frans Pop wrote:
> > I could solve this issue in two ways:
> > - boot with VGA=791 parameter (initial boot was without VGA= parameter)
> > - compile kernel without FRAMEBUFFER_CONSOLE_DETECT_PRIMARY set (I also
> >   unset FB_VIRTUAL, but without its boot param that should be a no-op)
>
> After looking at vfb.c again, it seems the default is for vfb to be
> enabled and you have to actively disable vfb either with
>
> video=vfb:disable or video=vfb:off
>
> I have to change this behavior. In the meantime, try one of the above
> options.

I'm not sure if there's been any progress on this issue, but to make sure it 
does not get forgotten, I've just filed a BR under drivers/video(other) and 
added that as blocker to #9056 (2.6.23 regressions):
http://bugzilla.kernel.org/show_bug.cgi?id=9310

Cheers,
FJP
