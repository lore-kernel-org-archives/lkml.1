Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbYBYMTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbYBYMTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 07:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbYBYMTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 07:19:43 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:54874 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbYBYMTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 07:19:43 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Date: Mon, 25 Feb 2008 13:19:03 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Greg KH" <greg@kroah.com>, "Alexey Zaytsev" <alexey.zaytsev@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Alexey Zaytsev" <zaytsev.a@protei.ru>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <47BEAF3B.3080809@protei.ru> <200802251054.57070.mb@bu3sch.de> <84144f020802250411i7a4a7c51h60ed9f9878c86422@mail.gmail.com>
In-Reply-To: <84144f020802250411i7a4a7c51h60ed9f9878c86422@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802251319.03819.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 February 2008 13:11:04 Pekka Enberg wrote:
> On Mon, Feb 25, 2008 at 11:54 AM, Michael Buesch <mb@bu3sch.de> wrote:
> >  > Isn't the resolution Michael is suggesting is, "use the different driver"?
> >
> >  I have two resolutions. One being:
> >  rmmod b44
> >  rmmod ssb
> >  modprobe bcm43xx
> >  modprobe b44
> >
> >  The other being: Wait for 2.6.25 and use the maintained b43 driver.
> 
> Neither of which seem like acceptable solutions for a 2.6.23 -> 2.6.24
> _regression_. Or maybe I am just too naive to believe Linus' statement
> on not letting the kernel regress...

So, please sign-off the patch that we have, if you think it's right
and doesn't cause more regressions.

-- 
Greetings Michael.
