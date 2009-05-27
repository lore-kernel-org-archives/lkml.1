Return-Path: <linux-kernel-owner+w=401wt.eu-S1760835AbZE0JFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760835AbZE0JFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 05:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756341AbZE0JFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 05:05:04 -0400
Received: from main.gmane.org ([80.91.229.2]:54041 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbZE0JFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 05:05:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alessandro Guido <alessandro.guido@gmail.com>
Subject: Higher wake-up rate when running on battery
Date: Wed, 27 May 2009 09:01:04 +0000 (UTC)
Message-ID: <loom.20090527T084654-793@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 151.65.184.135 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b4) Gecko/20090525 Gentoo Firefox/3.5b4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can observe a strange behaviour wrt timer wake-ups when looking at powertop:

 - when running on AC, about 8 wake-ups per second.

 - when running on battery, the number of wake-ups grows to about 11 and the
main wake-up producers are:
  23.1% (  3.9)     <kernel core> : hrtimer_start_range_ns (tick_sched_timer)
  19.2% (  3.2)       <interrupt> : acpi


[ These wake-up rates refer to X running KDE4, wi-fi off (by physical switch)
and no usb device connected. ]

Is this a normal behaviour?

