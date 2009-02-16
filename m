Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbZBPVCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbZBPVCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZBPVC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:02:28 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:48594 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbZBPVC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:02:28 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12510] 2.6.29-rc2 dies on startup
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
	<rjPbZ5GRJPO.A.jxF.ls0lJB@chimera>
Date: Mon, 16 Feb 2009 22:02:20 +0100
In-Reply-To: <rjPbZ5GRJPO.A.jxF.ls0lJB@chimera> (Rafael J. Wysocki's message
	of "Sat, 14 Feb 2009 21:38:17 +0100 (CET)")
Message-ID: <87ab8mt7s3.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12510
> Subject		: 2.6.29-rc2 dies on startup
> Submitter	: Ferenc Wagner <wferi@niif.hu>
> Date		: 2009-01-19 12:53 (27 days old)
> References	: http://marc.info/?l=linux-kernel&m=123236969321703&w=4

This is fixed in 2.6.29-rc5 by

commit 5701c0519b7a357a602fda5c96f26197ecfc4c85
Author: Arve Hjønnevåg <arve@android.com>
Date:   Fri Jan 30 20:21:09 2009 -0800

    Staging: android: ram_console: Disable ECC when early init is
    enabled and validate buffer size
-- 
Thanks,
Feri.
