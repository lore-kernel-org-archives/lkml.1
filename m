Return-Path: <linux-kernel-owner+w=401wt.eu-S1762082AbYEBMTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762082AbYEBMTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbYEBMTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:19:46 -0400
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:55562
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756921AbYEBMTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:19:46 -0400
Date: Fri, 2 May 2008 05:19:45 -0700
From: Phil Oester <kernel@linuxace.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ryan Roth <ryanroth@sbcglobal.net>, Ryan.Roth@CH2M.com,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults onMacBookStarting With 2.6.24.5 Kernel
Message-ID: <20080502121945.GA18667@linuxace.com>
References: <20080501130444.cc5c63e8.akpm@linux-foundation.org> <86A21F45FFA48B408A65E67054362EB6069DD742@CULEBRA.amr.ch2m.com> <20080501133003.be723364.akpm@linux-foundation.org> <86A21F45FFA48B408A65E67054362EB621C948@CULEBRA.amr.ch2m.com> <481A5276.4040607@sbcglobal.net> <20080501170239.9b740877.akpm@linux-foundation.org> <481A5A94.2080400@sbcglobal.net> <20080501173408.384b4fc3.akpm@linux-foundation.org> <20080502020815.GA5155@linuxace.com> <20080501192838.8ecb81c2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501192838.8ecb81c2.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 07:28:38PM -0700, Andrew Morton wrote:
> On Thu, 1 May 2008 19:08:15 -0700 Phil Oester <kernel@linuxace.com> wrote:
> 
> > FWIW, I recently upgraded some boxes to 2.6.24.x, and started seeing tons of
> > qmail segfaults, which look remarkably similar to the above problem.  2.6.21
> > did not exhibit this issue.
> > 
> > May  1 22:06:03 mail80 kernel: qmail-smtpd[5319]: segfault at 0 ip 4884b473 sp fffeec1c error 4 in libc-2.6.so[487dd000+14e000]
> > May  1 22:06:03 mail80 kernel: qmail-smtpd[5491]: segfault at 0 ip 4884b473 sp ffb7179c error 4 in libc-2.6.so[487dd000+14e000]
> > May  1 22:06:03 mail80 kernel: qmail-smtpd[4669]: segfault at 0 ip 4884b473 sp fff3135c error 4 in libc-2.6.so[487dd000+14e000]
> > May  1 22:06:05 mail80 kernel: qmail-smtpd[5906]: segfault at 0 ip 4884b473 sp ffe1b24c error 4 in libc-2.6.so[487dd000+14e000]
> > May  1 22:06:07 mail80 kernel: qmail-smtpd[5898]: segfault at 0 ip 4884b473 sp ffe4e27c error 4 in libc-2.6.so[487dd000+14e000]
> > May  1 22:06:11 mail80 kernel: qmail-smtpd[5840]: segfault at 0 ip 4884b473 sp ffe04a2c error 4 in libc-2.6.so[487dd000+14e000]
> > 
> 
> Can you try fiddling with the norandmaps boot option and
> /proc/sys/kernel/randomize_va_space?

echo 0 > /proc/sys/kernel/randomize_va_space does not make any difference (and
is equivalent to norandmaps boot option according to docs).

Unless you have other ideas, I can try to bisect this later today.

Phil
