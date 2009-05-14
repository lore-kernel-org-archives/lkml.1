Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZENKH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZENKH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 06:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZENKHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 06:07:11 -0400
Received: from nexus.dynaweb.hu ([195.70.37.87]:39372 "EHLO nexus.dynaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbZENKHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 06:07:10 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 May 2009 06:07:10 EDT
Date: Thu, 14 May 2009 12:00:54 +0200
From: RUMI Szabolcs <rumi_ml@rtfm.hu>
To: linux-kernel@vger.kernel.org
Subject: Intel Atom N280 cpufreq scaling problem
Message-Id: <20090514120054.2e231948.rumi_ml@rtfm.hu>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there!

I've got a shiny new netbook here with an Atom N280 1.66GHz (667MHz FSB)
currently running Ubuntu 9.04 (Jaunty) from a LiveUSB key and the cpufreq
scaling only scales between 800MHz and 1.33GHz but never sets the maximum
supported speed of 1.66GHz.

# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
1333000 1066000 800000

# uname -a
Linux ubuntu 2.6.28-11-generic #42-Ubuntu SMP Fri Apr 17 01:57:59 UTC 2009 i686 GNU/Linux

This is a relatively new chip released only a few months ago:
http://ark.intel.com/cpu.aspx?groupID=41411

Is this a known problem? Is there maybe a fix?
It could be due to my insufficient g00gling skills but I couldn't
find anything about this issue so far...

Thanks,

Sab
