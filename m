Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbYCNQj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbYCNQj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 12:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbYCNQju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 12:39:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41611 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbYCNQjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 12:39:49 -0400
Date: Fri, 14 Mar 2008 09:38:14 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Joel K. Greene" <joel.greene@catapult.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Timer interrupt stops, causes soft lockup
Message-ID: <20080314093814.3147f250@laptopd505.fenrus.org>
In-Reply-To: <1205510009.29658.83.camel@linuxdt036.nc.catapult.com>
References: <1204653133.718.14.camel@linuxdt036.nc.catapult.com>
	<47CD634E.2828.00B3.0@novell.com>
	<1204722318.6578.12.camel@linuxdt036.nc.catapult.com>
	<47CE45D8.2828.00B3.0@novell.com>
	<1204728175.6578.23.camel@linuxdt036.nc.catapult.com>
	<47D3DC53.2828.00B3.0@novell.com>
	<1205152374.18463.17.camel@linuxdt036.nc.catapult.com>
	<1205235450.18463.45.camel@linuxdt036.nc.catapult.com>
	<47D6423D.1E6F.00AA.0@novell.com>
	<1205255048.18463.60.camel@linuxdt036.nc.catapult.com>
	<1205260328.18463.67.camel@linuxdt036.nc.catapult.com>
	<47D68B9D.1E6F.00AA.0@novell.com>
	<1205265642.18463.82.camel@linuxdt036.nc.catapult.com>
	<1205322793.20205.9.camel@linuxdt036.nc.catapult.com>
	<1205326713.20205.27.camel@linuxdt036.nc.catapult.com>
	<1205332212.20205.33.camel@linuxdt036.nc.catapult.com>
	<1205510009.29658.83.camel@linuxdt036.nc.catapult.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008 11:53:29 -0400
"Joel K. Greene" <joel.greene@catapult.com> wrote:

> We originally saw this on the SLED10 kernel - SuSE's version of
> 2.6.16.21 - where the issue would occur in a matter of weeks or
> months.

Hi,

this is roughly a 3 year old kernel; and the thing is, this code has been
revamped entirely several times since then. Do you see this behavior with,
say the 2.6.24 kernel? That's a twofold question, since it has with-tickless 
and without-tickless as option. (tickless doesn't tend to use the PIT at all
so would just avoid the entire issue; without-tickless still uses the PIT)

It's really better to use your support contract with Novell to get them to fix
it for SLE(S/D)10 if you are not in a position to test or diagnose with new
kernels; they're there to support you for their old kernel. In general, the folks
on this list are working on current kernels and don't tend to spend time working
on such old kernels. The probability of this bug being fixed since then, or the fix
being totally not applicable to current kernels, is quite high (given the several rewrites
of the timer code) so it'd be a waste of the time of the people on this list.

Now, if you can see the behavior on 2.6.24 (or better, the latest 2.6.25-rc), then
suddenly you'll find a lot more people who're going to be interested....


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
