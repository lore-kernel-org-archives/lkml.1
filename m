Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbZBHS0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbZBHS0D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 13:26:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbZBHSZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 13:25:53 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:44868 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbZBHSZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 13:25:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type:content-transfer-encoding;
        b=OMjOUX6VPe87yBTcwJCPb2OpzUYFdIL7LdaxwrpIkUzFkrdw842LfHrbyQk2IhUvAv
         JSAQK8xmZTaHOJ5xd/xLDd0x7XRNdeAnCRrDxcLJyixv8Qd+8BsLvGLYOAIcxKD3J6Sg
         mATG5kEhMmPZ5eQmgtayQxVVzxBgcbQXVIJEE=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
Date: Mon, 9 Feb 2009 07:25:50 +1300
Message-ID: <cfd18e0f0902081025t3fe333ev1616af990e6d19ce@mail.gmail.com>
Subject: Why does timerfd() only support CLOCK_REALTIME and CLOCK_MONOTONIC?
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

At the moment I'm looking into writing man pages for timer_create(2)
and friends.  (Somewhat bizarrely, these pages do not yet exist.)  As
I looked into the source code of timer_create(), etc., and did some
tests, I saw that timer_create() supports the following clocks:

TIMER_REALTIME
TIMER_MONOTONIC
TIMER_PROCESS_CPUTIME_ID
TIMER_THREAD_CPUTIME_ID
clockid obtained from clock_getcpuclockid(3)
clockid obtained from pthread_getcpuclockid(3)

On the other hand, timerfd() only permits the first two of these.
What's the reason for that limitation of timerfd()?  (It may be worth
adding something to the man page on this point.)

Cheers,

Michael
-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
