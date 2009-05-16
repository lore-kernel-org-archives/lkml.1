Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbZEPXO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbZEPXO7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 19:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbZEPXOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 19:14:49 -0400
Received: from smtp.unchartedbackwaters.co.uk ([78.110.170.111]:36594 "EHLO
	smtp.unchartedbackwaters.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754829AbZEPXOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 19:14:48 -0400
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 May 2009 19:14:48 EDT
Message-ID: <4A0F46F9.6080406@unchartedbackwaters.co.uk>
Date: Sun, 17 May 2009 00:06:33 +0100
From: Francis Russell <francis+lkml@unchartedbackwaters.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Spurious power button event on resume from hibernate on Samsung R560
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have a Samsung R560 laptop running amd64 Debian testing with a
2.6.29.3 kernel compiled from vanilla sources. Upon resume from
hibernate, it appears that the OS receives a power button event that
causes the system to shut down. I've verified this the best I can by
killing acpid then watching the output of /proc/acpi/event during
hibernate (triggered by writing 'disk' to /sys/power/state).

This problem looked very similar to that discussed in another Bugzilla
entry (http://bugzilla.kernel.org/show_bug.cgi?id=6612) so I had I
extended the changes made by the patch in the obvious way to the S4
state but it made no difference. Is this something the kernel should be
handling? How can I debug this further?

Many thanks,

Francis
