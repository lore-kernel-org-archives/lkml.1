Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZKUAGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZKUAGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 19:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbZKUAGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 19:06:36 -0500
Received: from solitude.tty.gr ([95.154.208.37]:33475 "EHLO mx.tty.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbZKUAGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 19:06:35 -0500
X-Greylist: delayed 1314 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 19:06:35 EST
Message-ID: <4B0729D8.3000105@debian.org>
Date: Sat, 21 Nov 2009 01:44:24 +0200
From: Faidon Liambotis <paravoid@debian.org>
Organization: Debian
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>, 557262@bugs.debian.org
CC: Dave Chinner <david@fromorbit.com>, submit@bugs.debian.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       linux-raid@vger.kernel.org, asterisk-users@lists.digium.com,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: Bug#557262: 2.6.31+2.6.31.4: XFS - All I/O locks up to D-state
 after	24-48 hours (sysrq-t+w available) - root cause found = asterisk
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>	<alpine.DEB.2.00.0910181607040.27363@p34.internal.lan>	<20091019030456.GS9464@discord.disaster>	<alpine.DEB.2.00.0910190431180.23395@p34.internal.lan>	<20091020003358.GW9464@discord.disaster>	<alpine.DEB.2.00.0910200431290.21878@p34.internal.lan>	<alpine.DEB.2.00.0910210618210.10288@p34.internal.lan> <alpine.DEB.2.00.0911201530500.10757@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0911201530500.10757@p34.internal.lan>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
 > Found root cause-- root cause is asterisk PBX software.  I use an
SPA3102.
> When someone called me, they accidentally dropped the connection, I called
> them back in a short period.  It is during this time (and the last time)
> this happened that the box froze under multiple(!) kernels, always when
> someone was calling.
<snip>
> I don't know what asterisk is doing but top did run before the crash
> and asterisk was using 100% CPU and as I noted before all other processes
> were in D-state.
> 
> When this bug occurs, it freezes I/O to all devices and the only way to
> recover
> is to reboot the system.
That's obviously *not* the root cause.

It's not normal for an application that isn't even privileged to hang
all I/O and, subsequently everything on a system.

This is almost probably a kernel issue and asterisk just does something
that triggers this bug.

Regards,
Faidon
