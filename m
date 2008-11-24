Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbYKXU5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbYKXU5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 15:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826AbYKXU5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 15:57:18 -0500
Received: from nn7.de ([85.214.94.156]:33699 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbYKXU5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:57:16 -0500
Subject: Re: [Bug #11698] 2.6.27-rc7, freezes with &gt; 1 s2ram cycle
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <V2w_GS-X2aE.A.rcH.ywIKJB@chimera>
References: <0kQZaQnNVIL.A.BhG.FwIKJB@chimera>
	 <V2w_GS-X2aE.A.rcH.ywIKJB@chimera>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Nov 2008 21:57:13 +0100
Message-Id: <1227560233.4881.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-22 at 21:59 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.26 and 2.6.27.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> be listed and let me know (either way).

current mainstream hangs on *every* resume (Carlos observed the same
hangs on wakeup from s2ram but while the cause for him were the wireless
drivers it must be something else here)...

so this bug and the bug I am having is again hidden under something
else. one thing I noticed: The machine resumes and numlock still works
when using an external usb keyboard. still no display and also no second
s2ram possible :(

Soeren

> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11698
> Subject		: 2.6.27-rc7, freezes with &gt; 1 s2ram cycle
> Submitter	: Soeren Sonnenburg <kernel@nn7.de>
> Date		: 2008-09-29 11:29 (55 days old)
> References	: http://marc.info/?l=linux-kernel&m=122268780926859&w=4
> Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
> 
> 
