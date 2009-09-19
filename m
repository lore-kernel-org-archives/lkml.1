Return-Path: <linux-kernel-owner+w=401wt.eu-S1752246AbZISS2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbZISS2n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 14:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZISS2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 14:28:42 -0400
Received: from mail-yw0-f141.google.com ([209.85.211.141]:46535 "EHLO
	mail-yw0-f141.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbZISS2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 14:28:42 -0400
MIME-Version: 1.0
Date: Sat, 19 Sep 2009 11:15:53 -0700 (PDT)
In-Reply-To: <dlohM-3zc-19@gated-at.bofh.it>
X-IP: 82.0.91.38
References: <dlohM-3zc-19@gated-at.bofh.it>
User-Agent: G2/1.0
X-HTTP-Via: 1.1 home (squid/3.0.STABLE8)
X-HTTP-UserAgent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.3) 
	Gecko/20090915 Ubuntu/9.10 (karmic) Firefox/3.5.3,gzip(gfe),gzip(gfe)
Message-ID: <a89c6653-c807-490b-9ecc-bac41c3d8ab5@k26g2000vbp.googlegroups.com>
Subject: Re: Linux not shutting down all devices? Battery drain in after 
	shutdown
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: Pavel Machek <pavel@ucw.cz>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 17, 1:30 pm, Norbert Preining <preining@logic.at> wrote:
> Dear all,
>
> I have a very strange problem with my Sony VAIO Z11 laptop. When I turn
> it off in Linux it still drains battery, and quite a lot indeed, several
> percent per hour.

As there is potential for broken BIOS/firmware to be mis/reprogramming
hardware at shutdown time, can you check with booting the kernel with
'reboot=pci' before shutting down?

This has the excellent effect on my Thinkpad T400 of avoiding a 9
second hang when powering off or rebooting [1], making it faster than
bootup (as it should be), though I haven't done any battery draining
measurements yet...

If code is being executed by the BIOS to reprogram devices, that 9
second hang may be due to timeouts when hardware isn't in the expected
state even.

I wonder if windows quiesces all devices and uses the pci poweroff/
reboot method or the keyboard controller method.

Daniel

--- [1]

http://groups.google.com/group/linux.kernel/browse_thread/thread/90f916ad67d5e7d3/f81bfd6af01fafb6?lnk=gst&q=blueman#f81bfd6af01fafb6
--
Daniel J Blueman
