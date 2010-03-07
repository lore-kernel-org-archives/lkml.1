Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0CGOaI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 09:30:08 -0500
Received: from noc.rz.fh-offenburg.de ([141.79.128.4]:37795 "EHLO
	noc.rz.fh-offenburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab0CGOaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 09:30:06 -0500
X-Greylist: delayed 1731 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Mar 2010 09:30:05 EST
Message-Id: <4B93BF8C020000DD00024397@tula.rz.fh-offenburg.de>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Sun, 07 Mar 2010 15:00:28 +0100
From: "Fabian Korak" <fkorak@stud.fh-offenburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: Perf doesn't accept i915:i915_gem_request_wait_begin as an
	event
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm currently trying to get the examples at http://dri.freedesktop.org/wiki/IntelPerformanceTuning to run, however when I try

perf record -f -g -e i915:i915_gem_request_wait_begin -c 1 openarena

I get the message "invalid or unsupported event: 'i915:i915_gem_request_wait_begin' ". It also isn't listed within perf list.
I'm currently on an up-to-date Fedora Core 14 rawhide with kernel 2.6.34-0.4.rc0.git2. Intel_gpu_tools and libdwarf is installed.
 I talked to a few guys on #xorg-devel yesterday and they told me to install kernel-debuginfo, which didn't change anything.
They also told me to run

nm /lib/modules/2.6.34-0.4.rc0.git2.fc14.x86_64/kernel/drivers/gpu/drm/i915/i915.ko | grep i915_gem

the output of that can be found here: http://www.pastebin.org/102547

Any help would be appreciated.

thx Fabian Korak
