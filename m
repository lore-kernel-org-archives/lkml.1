Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbZEKA1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbZEKA1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 20:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757322AbZEKA0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 20:26:52 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:54601 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757028AbZEKA0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 20:26:51 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: Regression in TSC unstable -- confirmed
Date: Mon, 11 May 2009 02:26:48 +0200
User-Agent: KMail/1.9.9
Cc: Steven Rostedt <rostedt@goodmis.org>, len.brown@intel.com, mingo@elte.hu,
       tglx@linutronix.de, johnstul@us.ibm.com
References: <alpine.DEB.2.00.0905072359530.28378@gandalf.stny.rr.com>
In-reply-To: <alpine.DEB.2.00.0905072359530.28378@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200905110226.50115.elendil@planet.nl>
X-OriginalArrivalTime: 11 May 2009 00:26:50.0393 (UTC) FILETIME=[2D393890:01C9D1CF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing the same issue with 2.6.30-rc5 (not tested previous RCs on that 
box) on a system for which TSC has always been usable.

$ dmesg | grep TSC
Fast TSC calibration using PIT
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Marking TSC unstable due to TSC halts in idle

The last line is new with 2.6.30. After reverting a71e4917dc0 the TSC 
works fine again.

The system has a Intel D945GCZ mainboard with dual core Pentium D 
(3.20GHz) processor running x86_64 and Debian Lenny.

Cheers,
FJP

(Thanks to Steven for doing the bisection.)
