Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbZCAPos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbZCAPos (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 10:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbZCAPoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 10:44:39 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:43749 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbZCAPoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 10:44:38 -0500
Date: Sun, 1 Mar 2009 15:44:33 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29-rc6 (clocksource)
Message-ID: <20090301154433.GA25246@silver.sucs.org>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain> <49A6F39F.9040801@krogh.cc> <49AAA50F.5070209@krogh.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AAA50F.5070209@krogh.cc>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 01, 2009 at 04:09:03PM +0100, Jesper Krogh wrote:
> Jesper Krogh wrote:
> >The "current_clocsource" is the same on both systems.
> >
> >$ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> >tsc
> 
> What selects the "current_clocksource"? I tried to boot one of the 
> kernels hat have the problem on another piece of hardware and on that 
> system it ended up defaulting to "acpi_pm" instead of "tsc".

I believe different clock sources have different priorities based on
their resolution and behaviour. Clock sources's that "go bad" because
hardware interactions are hopefully detected and subsequent "best" clock
sources are then tried.

There was a nice treatment of different clocksourcs in this
kernelnewbies thread:
http://www.mail-archive.com/kernelnewbies@nl.linux.org/msg05164.html .

-- 
Sitsofe | http://sucs.org/~sits/
