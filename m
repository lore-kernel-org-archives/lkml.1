Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240Ab0AYMvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab0AYMvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 07:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133Ab0AYMvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 07:51:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:56436 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab0AYMvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 07:51:08 -0500
Subject: Re: Warnings about tasks on CPU 1 during STR
From: Peter Zijlstra <peterz@infradead.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <201001250542.08642.elendil@planet.nl>
References: <201001250542.08642.elendil@planet.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 13:50:59 +0100
Message-ID: <1264423859.4283.1725.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 05:42 +0100, Frans Pop wrote:
> With 2.6.33-rc5 during suspend to RAM I'm getting a bunch of warnings
> I've not seen with earlier kernel versions:
> 
> PM: late suspend of devices complete after 28.784 msecs
> ACPI: Preparing to enter system sleep state S3
> Disabling non-boot CPUs ...
> CPU 1 is now offline
> SMP alternatives: switching to UP code
> Task events/1 (pid = 10) is on cpu 1 (state = 1, flags = 84208040)
> Task khelper (pid = 11) is on cpu 1 (state = 1, flags = 80208040)
> Task sync_supers (pid = 77) is on cpu 1 (state = 1, flags = 80208040)
> Task bdi-default (pid = 79) is on cpu 1 (state = 2, flags = 80a15040)
> Task kblockd/1 (pid = 81) is on cpu 1 (state = 1, flags = 84208040)
> [...]
> Task pm-suspend (pid = 29782) is on cpu 1 (state = 2, flags = 414000)
> Extended CMOS year: 2000
> Back to C!
> 
> All the "Task X is on cpu 1" messages (76 in total) are new. Bug or
> intentional? As it is a warning, I suspect a bug.

http://lkml.org/lkml/2010/1/21/175

