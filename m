Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbYHHJiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbYHHJiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 05:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbYHHJiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 05:38:06 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:25559 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbYHHJiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 05:38:05 -0400
Date: Fri, 8 Aug 2008 11:37:53 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: "D. Kelly" <user.kernel@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       "mailing list: linux-kernel" <linux-kernel@vger.kernel.org>,
       Linux I2C <i2c@lm-sensors.org>
Subject: Re: Problem with restricted I2C algorithms in kernel 2.6.26!
Message-ID: <20080808113753.03f49efe@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.58.0808071621060.22108@shell2.speakeasy.net>
References: <5ab239b10807161233i6c1c4d0we01ea1b8e6ccaa5b@mail.gmail.com>
	<20080807131357.59399ddf@hyperion.delvare>
	<Pine.LNX.4.58.0808070851310.10341@shell4.speakeasy.net>
	<20080807181416.5de4ce6d@hyperion.delvare>
	<Pine.LNX.4.58.0808071621060.22108@shell2.speakeasy.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trent,

On Thu, 7 Aug 2008 16:41:10 -0700 (PDT), Trent Piepho wrote:
> Expecting every developer to keep abreast of linux-next and the tens of
> thousands of patches it gets just isn't realisitic.
> 
> The embedded platforms I develop on won't run linux-next.  Continuously
> porting them to linux-next is simply impossible.  The man hours required to
> do that would be staggering.

Once again a "believe me it's impossible" without any good reason
given. I fail to see why embedded platforms would be any different from
other platforms or subsystem trees. Please enlighten me.

> The pool of testers available to a driver that requires running linux-next
> is going to be orders of magnitude less that a driver that can be compiled
> out of tree against 2.6.19 to 2.6.27.

Except that distributions start packaging linux-next, while in general
they don't package out-of-tree versions of packages that are also
available in the kernel tree. If the v4l-dvb tip was in linux-next (it
isn't, is it?), I suspect that you would get many more testers than you
have at the time being. Which doesn't mean that you can't additionally
provide out-of-tree drivers for older kernels if you think it's worth
the additional effort (I don't think it is, but it's up to whoever does
the work.)

-- 
Jean Delvare
