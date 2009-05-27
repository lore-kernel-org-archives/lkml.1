Return-Path: <linux-kernel-owner+w=401wt.eu-S1757629AbZE0Qqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbZE0Qqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 12:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZE0Qqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 12:46:47 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:36818 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbZE0Qqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 12:46:46 -0400
Message-ID: <4A1D6E71.90602@nortel.com>
Date: Wed, 27 May 2009 10:46:41 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: linux missing support for _POSIX_THREAD_CPUTIME?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2009 16:46:45.0585 (UTC) FILETIME=[B87F8C10:01C9DEEA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

POSIX defines optional support for clock ID values obtained by invoking
pthread_getcpuclockid().  When passed to clock_gettime(), this allows
the caller to request the CPU-time clock of an arbitrary thread within
the same process as the caller.

It appears that linux doesn't support this functionality--is that
correct?  Is there any plan to enable this?

Is there any current way to obtain the runtime of a particular thread
without knowing its tid (since the thread_id to tid mapping is known
only to glibc)?

Thanks,

Chris
