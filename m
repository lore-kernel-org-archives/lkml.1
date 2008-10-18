Return-Path: <linux-kernel-owner+w=401wt.eu-S1751669AbYJRR1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbYJRR1r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 13:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbYJRR1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 13:27:39 -0400
Received: from smtp2.sms.unimo.it ([155.185.44.12]:40476 "EHLO
	spostino.sms.unimo.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750922AbYJRR1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 13:27:39 -0400
X-Greylist: delayed 2292 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Oct 2008 13:27:38 EDT
Subject: LatencyTop problem
From: Mauro Andreolini <mauro.andreolini@unimore.it>
Reply-To: mauro.andreolini@unimore.it
To: linux-kernel@vger.kernel.org, mauro.andreolini@unimore.it
Content-Type: text/plain
Organization: =?ISO-8859-1?Q?Universit=E0?= di Modena e Reggio Emilia
Date: Sat, 18 Oct 2008 18:49:18 +0200
Message-Id: <1224348558.7067.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SPF-Guess: softfail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I tried to get latencytop (Debian testing package, v.0.4) running on a
2.6.27 vanilla kernel. When I try to execute latencytop as root, I get
the following message:

Error writing to /proc/sys/kernel/latencytop: No such file or directory
Error writing to /proc/sys/kernel/latencytop: No such file or directory
Are you root?
Please enable the CONFIG_LATENCYTOP configuration in your kernel.
Exiting...

I am pretty sure that the CONFIG_LATENCYTOP is set in the kernel.
I tried to download and apply the latencytop patch, but it rejects some
hunks. It seems as if the executable wants to
open /proc/sys/kernel/latencytop for writing but it can't, because the
piece of kernel code that enables it (kernel/latencytop.c) does not
create that /proc file. The code to enable /proc/sys/kernel/latencytop
is contained in the kernel patch from the project home page, anyway.
Instead, reading the code in the 2.6.27 kernel, a "latency_stats" file
should be created, but that is not present under both the /proc and /sys
filesystems.
Could anyone of you point me to a procedure to get latencytop working
with a recent kernel?
Thank you in advance.

Mauro Andreolini

