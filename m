Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbYKFUrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbYKFUrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbYKFUrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:47:09 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:56357 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbYKFUrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:47:08 -0500
Date: Thu, 06 Nov 2008 13:56:16 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: 2.6.28-rc2-mm1: multiple BUG: scheduling while atomic: swapper,
 first in acpi_idle_enter_simple, then fbcon has problems
In-reply-to: <20081106093324.57d88a43.akpm@linux-foundation.org>
X-X-Sender: lenb@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.2.00.0811061354340.3106@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081106102309.GA334@atrey.karlin.mff.cuni.cz>
 <20081106093324.57d88a43.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > ...kernel contains experimental version of HP accelerometer driver and
> > new HP acclerometer LED, but hopefully they are not causing this?
> > 
> 
> The trace is a bit of a mess, but we first hit problems around
> acpi_idle(), so I'd be suspecting acpi, x86 or sched-type changes.

try "idle=poll" to run none of the ACPI idle code.
or "idle=halt" to just flirt with the idle code.

-Len
