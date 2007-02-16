Return-Path: <linux-kernel-owner+w=401wt.eu-S1422920AbXBPB3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422920AbXBPB3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 20:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932427AbXBPB3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 20:29:30 -0500
Received: from epsilon2.look.ca ([207.136.100.6]:51157 "EHLO gozer.look.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932423AbXBPB33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 20:29:29 -0500
Date: Thu, 15 Feb 2007 20:30:24 -0500
To: linux-kernel@vger.kernel.org
Message-ID: <20070216013024.GA32287@infidigm.net>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
From: Jeff Muizelaar <jeff@infidigm.net>
X-SA-Exim-Mail-From: jeff@infidigm.net
Subject: Using sched_clock for mmio-trace
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Version: 3.1 (built Tue Feb 24 05:09:27 GMT 2004)
X-SA-Exim-Scanned: Yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've built a tool with the goal of logging mmio writes and reads by
device drivers. See http://nouveau.freedesktop.org/wiki/MmioTrace.

I'd like to add support for recording a time stamp on each read and
write. Unfortunately, I am not sure which clock api I should use.

I had a look at blktrace and saw that it uses 'sched_clock()' for time
stamps. However, this symbol is not exported to modules, and from what
I've read it sounds like its use is discouraged.

The question is, what api should I be using? I need something that can
be called from inside interrupt handlers, and obviously the more
accurate and the lower the overhead the better.

-Jeff
