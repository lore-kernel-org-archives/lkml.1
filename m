Return-Path: <linux-kernel-owner+w=401wt.eu-S934804AbXGQVKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934804AbXGQVKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbXGQVKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:10:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:35514 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754185AbXGQVKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:10:40 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX180ivUbulM0Gtf7NGfXyCG2GUDyXo1WOOIwnOQJz8
	TihCEV3ItaqaLA
Message-ID: <469D2A40.2060008@gmx.net>
Date: Tue, 17 Jul 2007 22:44:48 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: signalfd and thread semantics
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

Working on the signalfd man page, another question comes up:

What are the intended semantics for a signalfd file descriptor with respect
to threads?  I have not yet tested the behavior, but in any case, I better
check what is expected.

A signal can be directed to the process as a whole (e.g., using kill(2)),
or to a particular thread (using, e.g., pthread_kill(2), or tgkill(2)).

So that raises the question: If a thread calls signalfd(), does the
resulting file descriptor return just those signals directed to [the thread
and the process as a whole], or will it also receive signals that are
targeted at other threads in the process?  I would hope the former is the
case, but I'm not sure what has been implemented (or intended).

Cheers,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.

