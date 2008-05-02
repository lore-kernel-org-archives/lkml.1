Return-Path: <linux-kernel-owner+w=401wt.eu-S1759484AbYEBC3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484AbYEBC3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 22:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbYEBC3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 22:29:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbYEBC3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 22:29:11 -0400
Date: Thu, 1 May 2008 19:28:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Phil Oester <kernel@linuxace.com>
Cc: Ryan Roth <ryanroth@sbcglobal.net>, Ryan.Roth@CH2M.com,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults
 onMacBookStarting With 2.6.24.5 Kernel
Message-Id: <20080501192838.8ecb81c2.akpm@linux-foundation.org>
In-Reply-To: <20080502020815.GA5155@linuxace.com>
References: <bug-10586-10286@http.bugzilla.kernel.org/>
	<20080501130444.cc5c63e8.akpm@linux-foundation.org>
	<86A21F45FFA48B408A65E67054362EB6069DD742@CULEBRA.amr.ch2m.com>
	<20080501133003.be723364.akpm@linux-foundation.org>
	<86A21F45FFA48B408A65E67054362EB621C948@CULEBRA.amr.ch2m.com>
	<481A5276.4040607@sbcglobal.net>
	<20080501170239.9b740877.akpm@linux-foundation.org>
	<481A5A94.2080400@sbcglobal.net>
	<20080501173408.384b4fc3.akpm@linux-foundation.org>
	<20080502020815.GA5155@linuxace.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 19:08:15 -0700 Phil Oester <kernel@linuxace.com> wrote:

> FWIW, I recently upgraded some boxes to 2.6.24.x, and started seeing tons of
> qmail segfaults, which look remarkably similar to the above problem.  2.6.21
> did not exhibit this issue.
> 
> May  1 22:06:03 mail80 kernel: qmail-smtpd[5319]: segfault at 0 ip 4884b473 sp fffeec1c error 4 in libc-2.6.so[487dd000+14e000]
> May  1 22:06:03 mail80 kernel: qmail-smtpd[5491]: segfault at 0 ip 4884b473 sp ffb7179c error 4 in libc-2.6.so[487dd000+14e000]
> May  1 22:06:03 mail80 kernel: qmail-smtpd[4669]: segfault at 0 ip 4884b473 sp fff3135c error 4 in libc-2.6.so[487dd000+14e000]
> May  1 22:06:05 mail80 kernel: qmail-smtpd[5906]: segfault at 0 ip 4884b473 sp ffe1b24c error 4 in libc-2.6.so[487dd000+14e000]
> May  1 22:06:07 mail80 kernel: qmail-smtpd[5898]: segfault at 0 ip 4884b473 sp ffe4e27c error 4 in libc-2.6.so[487dd000+14e000]
> May  1 22:06:11 mail80 kernel: qmail-smtpd[5840]: segfault at 0 ip 4884b473 sp ffe04a2c error 4 in libc-2.6.so[487dd000+14e000]
> 

Can you try fiddling with the norandmaps boot option and
/proc/sys/kernel/randomize_va_space?
