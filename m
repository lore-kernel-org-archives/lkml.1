Return-Path: <linux-kernel-owner+w=401wt.eu-S1161454AbXB0AI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161454AbXB0AI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161457AbXB0AIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:08:01 -0500
Received: from smtp.osdl.org ([65.172.181.24]:39211 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161454AbXB0AHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:07:15 -0500
Date: Mon, 26 Feb 2007 16:07:08 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC] div64_64 support
Message-ID: <20070226160708.3c7a8d29@freekitty>
In-Reply-To: <Pine.LNX.4.61.0702270103060.23355@yvahk01.tjqt.qr>
References: <20070223170527.4ca695b2@freekitty>
	<Pine.LNX.4.61.0702262108010.23355@yvahk01.tjqt.qr>
	<20070226143127.5c74bec9@freekitty>
	<Pine.LNX.4.61.0702262348140.23355@yvahk01.tjqt.qr>
	<20070226154413.4ead571a@freekitty>
	<Pine.LNX.4.61.0702270103060.23355@yvahk01.tjqt.qr>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Feb 2007 01:05:26 +0100 (MET)
Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> 
> On Feb 26 2007 15:44, Stephen Hemminger wrote:
> >> >-		x = (2 * x + (uint32_t) div64_64(a, x*x)) / 3;
> >> >+		x = (2 * x + (u32) (a / x*x)) / 3;
> >> 
> >> Previously there was div64_64(a, x*x) which is equivalent to
> >> (a)/(x*x), or just: a/(x^2). But now you do a/x*x, which is
> >> equivalent to a*x/x (in the domain of real numbers). Furthermore,
> >> a/x*x is a-(a%x), which does not even remotely match a/(x^2).
> >> 
> >Been there, done that, don't want to repeat it...
> 
> I am sorry I don't quite follow.

Once before a missed paren's caused a TCP congestion window bug that
took 6 months before it was found...

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
