Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbXFPTqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbXFPTqo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 15:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbXFPTqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 15:46:37 -0400
Received: from ipx20189.ipxserver.de ([80.190.249.56]:4705 "EHLO
	ipx20189.ipxserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbXFPTqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 15:46:36 -0400
Date: Sat, 16 Jun 2007 21:46:34 +0200
From: Christian Leber <christian@leber.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: beeping patch for debugging acpi sleep
Message-ID: <20070616194634.GA15953@core>
References: <20070518213701.GA810@core> <20070520200142.GB5235@ucw.cz> <20070602182014.GB29546@core> <20070609130817.GI27793@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070609130817.GI27793@elf.ucw.cz>
X-Accept-Language: de en
X-Location: Europe, Germany, Mannheim
X-Operating-System: Debian GNU/Linux (sid)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 03:08:17PM +0200, Pavel Machek wrote:

> Starting beeper as soon as ACPI sleep returns is very useful in
> debugging "apparently dead" machines. If it beeps at all, it makes
> sense to start playing with CMOS tracer.

thank you very much Pavel

The results are a bit unclear, I took a 2.6.22-rc4 with beep.
Logged into KDE.
(hardware: Dell Latitude D810)

S = successfull resume
D = had to resume 2 times, that means when pressing the power button the
LED goes from blinking to on and after a few seconds it goes back to
blinking, but without a beep in between; after pressing the power button
a second time resume is successfull
F = resume failes, NO beep

-run 1: D D F
-run 2: D D D(some X garbadge) F
-run 3: S S S S S S F
-run 4: S S F
-run 5: D F

Very odd, nothing was changed in between and after each F i switched it
off... because it was dead.

With 2.6.19.7 i have never seen it fail.


Christian Leber

-- 
http://rettetdieti.vde-uni-mannheim.de/

