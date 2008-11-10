Return-Path: <linux-kernel-owner+w=401wt.eu-S1755420AbYKJMEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbYKJMEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 07:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbYKJMEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 07:04:06 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:42645 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbYKJMEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 07:04:04 -0500
Date: Mon, 10 Nov 2008 13:04:01 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Bug #11989] Suspend failure on NForce4-based boards due to
	chanes in stop_machine
Message-ID: <20081110120401.GA15518@osiris.boeblingen.de.ibm.com>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera> <wnN9HICUAgP.A.00E.N4zFJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wnN9HICUAgP.A.00E.N4zFJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 06:59:16PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11989
> Subject		: Suspend failure on NForce4-based boards due to chanes in stop_machine
> Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
> Date		: 2008-11-03 0:28 (7 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c9583e55fa2b08a230c549bd1e3c0bde6c50d9cc
> References	: http://marc.info/?l=linux-kernel&m=122567187604356&w=4

Hi Rafael,

could you provide more informations for this, please?

What is your kernel configuration?
Do you have any binary only modules (nvidia?) loaded?

Is it possible to recreate the bug by e.g. just doing something like

echo 0 > /sys/devices/system/cpu/cpu1/online

(or any other online cpu)? Or does it trigger any lockdep warnings?
