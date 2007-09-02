Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbXIBRks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbXIBRks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 13:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbXIBRkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 13:40:41 -0400
Received: from ipx20189.ipxserver.de ([80.190.249.56]:2669 "EHLO
	ipx20189.ipxserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbXIBRkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 13:40:40 -0400
Date: Sun, 2 Sep 2007 19:40:38 +0200
From: Christian Leber <christian@leber.de>
To: linux-kernel@vger.kernel.org
Subject: Linux, 2.6.23-rc5, powersaving degradation, (time spend in C0 goes up after a while)
Message-ID: <20070902174038.GA10877@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Accept-Language: de en
X-Location: Europe, Germany, Mannheim
X-Operating-System: Debian GNU/Linux (sid)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have observed some oddness in the powersaving behavior in rc5 and the
rcs before and i suspect this may be scheduler related.

After booting or resuming from drisk or ram(!) the wakeups are about
45 per second (about 1% C0 (cpu runng)) and after
about half an hour to hours of doing nothing with the laptop besides
having a powertop in konsole the wakeups rise to about 6200 and the cpu
is running 55% of the time.

(with rc3 this was odder, it took three time pretty exactly 43min until
this occured)

I appended the output of powertop and the .config.
But powertop doesn't even show the reason for the wakeups, probably they
don't exist, but the power usage really goes up.

The hardware is btw. Dell latitude d830 (intel T7300, intel wlan and
gfx)

It's not a bad bug, it's just odd and eats about 4W of power.


Christian Leber

-- 
http://rettetdieti.vde-uni-mannheim.de/

