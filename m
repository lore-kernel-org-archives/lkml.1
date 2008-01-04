Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbYADPQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbYADPQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 10:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbYADPQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 10:16:08 -0500
Received: from server.lespinasse.org ([64.142.28.226]:48229 "EHLO
	server.lespinasse.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbYADPQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:16:07 -0500
X-Greylist: delayed 2006 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jan 2008 10:16:07 EST
Date: Fri, 4 Jan 2008 06:42:38 -0800
From: Michel Lespinasse <walken@zoy.org>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Asus P1-AH2 won't suspend (regression)
Message-ID: <20080104144238.GA5176@zoy.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm unable to get an asus P1-AH2 system to suspend (to ram). The issue
occurs at suspend time: the system displays "Suspending console(s)" but
does not turn off the screen and system fans.

I used to have suspend/resume working fine on this system using a
2.6.20.x kernel. Yes, I know this is a huge range... suspend has
been broken on this sytem since at least 2.6.22.x

I tried running 2.6.24-rc6 with verbose PM debugging and suspend/resume
event tracing. Still no luck, the last message I see is still
"Suspending console(s)". The information from event tracing seems to be:
  Magic number: 8:471:282
  hash matches device tty19

I'm not sure if that's any help. Is there any way to help figure out the
problem besides a git bisect ? would extra event traces during/after the
suspend console stage help ???

This is with an x86_64 kernel. .config file can be found at
http://lespinasse.org/config-2.6.24-rc6 if that's any help.

Thanks,

-- 
Michel Lespinasse
