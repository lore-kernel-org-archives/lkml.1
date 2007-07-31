Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbXGaWyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbXGaWyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbXGaWyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:54:06 -0400
Received: from norsk.toidinamai.de ([78.47.249.60]:45430 "EHLO
	norsk.toidinamai.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbXGaWyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:54:05 -0400
X-Greylist: delayed 1873 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 18:54:05 EDT
Message-ID: <46AFB62E.2080303@benkstein.net>
Date: Wed, 01 Aug 2007 00:22:38 +0200
From: Frank Benkstein <frank-lkml@benkstein.net>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: VT_PROCESS, VT_LOCKSWITCH capabilities
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wonder why there are different permissions needed for VT_PROCESS
(access to the current virtual console) and VT_LOCKSWITCH
(CAP_SYS_TTY_CONFIG).

The first one lets the calling process decide if console switching is
allowed, the second one simply disables it.  If a program wants to
forbid console switching the only technical difference I can see is that
switching is automatically reenabled when the program exits when using
VT_PROCESS.  When using VT_LOCKSWITCH it must be manually reenabled.
When the program uses the first method and disables terminal signals and
SysRQ is disabled, too, I see no practical difference between the two.

Please CC me on replies, I am not on the list.

Best regards
Frank Benkstein.
