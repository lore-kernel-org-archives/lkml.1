Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbYGRBZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbYGRBZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 21:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYGRBZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 21:25:18 -0400
Received: from c-68-35-23-177.hsd1.nm.comcast.net ([68.35.23.177]:56077 "EHLO
	deneb.dwf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbYGRBZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 21:25:17 -0400
X-Greylist: delayed 3973 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jul 2008 21:25:17 EDT
Message-Id: <200807180019.m6I0J2kG026240@deneb.dwf.com>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
To: linux-kernel@vger.kernel.org
Subject: Does 2.6.26 provide nanosecond time to the user?
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 17 Jul 2008 18:19:02 -0600
From: Reg Clemens <reg@dwf.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Im confused.
(sorry I havent been following the linux-kernel mailing list on this)

Does 2.6.26 use nanosecond time
    (1) internally?
    (2) provide it to the user?

I see no way to turn it on/off in xconfig.
Yet I do see STA_NANO defined in sys/timex.h which is a good start.

and IF it provides it to the user, what do I use to get nanosecond time.
My search with man -k for timespec turns up
      sys_clock_getres
and sys_clock_gettime

or possibly clock_getres and clock_gettime, the man pages use both,
but NONE of these entry points seem to exist in my system.

Puzzled.


-- 
                                        Reg.Clemens
                                        reg@dwf.com


