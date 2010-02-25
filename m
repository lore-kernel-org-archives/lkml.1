Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934335Ab0BYWry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 17:47:54 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:44520 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934287Ab0BYWrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 17:47:53 -0500
Date: Thu, 25 Feb 2010 23:33:44 +0100
From: Jens Seidel <jensseidel@users.sf.net>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Jens Seidel <jensseidel@users.sf.net>
Subject: Re: CE: xen increasing min_delta_ns to 7651397591976463850 nsec /
	pvops domU
Message-ID: <20100225223342.GA2230@merkur.sol.de>
Mail-Followup-To: Jens Seidel <jensseidel@users.sf.net>,
	linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
References: <20100222082657.GA26436@merkur.sol.de> <20100225214442.GG2761@reaktio.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100225214442.GG2761@reaktio.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Provags-ID: V01U2FsdGVkX18uVPMmPeEu37dTcQa68uUK6e7zGxYSC3RWZvOF
	FkxAiiQtXzfDfBeSdjyBMegHANwPwd+uzG8uoMUuw9XRDeEWAY
	qXZQy7XLU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 11:44:42PM +0200, Pasi Kärkkäinen wrote:
> CCing to xen-devel..

thanks Pasi ...

I have more information:
 
> On Mon, Feb 22, 2010 at 09:26:59AM +0100, Jens Seidel wrote:
> > I'm using vanilla 2.6.32.7 domU kernel with Xen 3.2 and get very often a
> > unresponsible system after approximately one or two days with messages such as

The problem seems to occur between 10h - 11.5h (verified three times).

Using the options "hpet=disable clocksource=jiffies nolapic acpi=off" the
problem vanished but I get a minor time drift between dom0 and domU (and
missed at least once my bus :-()

> > [43616.674502] CE: xen increasing min_delta_ns to 16086592372704132408 nsec
> > 
> > on the console. I fail to login via ssh and even to cleanly shutdown this
> > system via xm <id> shutdown. sysrq requests still work.

Oops, forget about sysrq. Now I think it didn't worked.

> > PS: Please CC: me.

Jens
