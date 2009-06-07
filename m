Return-Path: <linux-kernel-owner+w=401wt.eu-S1758884AbZFGNNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884AbZFGNNI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758454AbZFGNKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 09:10:10 -0400
Received: from fmailhost06.isp.att.net ([204.127.217.106]:48918 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756847AbZFGNKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 09:10:08 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A2BBC30.2030300@lwfinger.net>
Date: Sun, 07 Jun 2009 08:10:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.hvH.Ha7KKB@chimera>
In-Reply-To: <D9VoutSOyXP.A.hvH.Ha7KKB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13319
> Subject		: Page allocation failures with b43 and p54usb
> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> Date		: 2009-04-29 21:01 (40 days old)
> References	: http://marc.info/?l=linux-kernel&m=124103897101088&w=4
> Handled-By	: Johannes Berg <johannes@sipsolutions.net>

This bug is extremely difficult to pin down. I cannot reproduce it at
will. The system has to be up for a long time, which is difficult with
testing the late RC's of 2.6.30 and the code in wireless-testing so
that new bugs don't end up in 2.6.31-RCX. That said, it still was in
2.6.30-RC6 and I'm not aware of any changes since that would fix it.

My operating kernel is patched with additional diagnostics to help me
understand why a kmalloc request for a buffer of 1390 bytes suddenly
ends up as an O(1) request. Unfortunately, I don't have any answers.

Larry
