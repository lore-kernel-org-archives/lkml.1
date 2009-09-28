Return-Path: <linux-kernel-owner+w=401wt.eu-S1752491AbZI1HYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbZI1HYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 03:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZI1HYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 03:24:00 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:55359 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZI1HYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 03:24:00 -0400
X-Greylist: delayed 780 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Sep 2009 03:23:59 EDT
Message-ID: <4AC06187.2050806@lumino.de>
Date: Mon, 28 Sep 2009 09:11:03 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Userspace RCU: (ab)using futexes to save cpu cycles and
 energy
References: <20090923174820.GA12827@Krystal> <4ABA631A.8030306@nortel.com> <20090923190337.GA16983@Krystal> <20090923223204.GA2921@Krystal> <4ABAAB4F.2060905@nortel.com> <20090923232855.GB9621@Krystal>
In-Reply-To: <20090923232855.GB9621@Krystal>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> The mutex code (and usual futex users) use futex to implement mutual
> exclusion.  My goal is to send a wakeup signal to a thread waiting for
> work to perform when adding such work. But without any mutual exclusion.

Why is that different ?

if you use a normal FUTEX like pthread_mutex_...() and have the thread
block right at the start (by blocking the *UTEX before creating the
thread). Now you can wake the thread by unblocking the *UTEX.

-Michael

