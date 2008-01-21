Return-Path: <linux-kernel-owner+w=401wt.eu-S932408AbYAUKZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408AbYAUKZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760681AbYAUKMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:12:03 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:44153 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761814AbYAUKMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:12:00 -0500
Date: Mon, 21 Jan 2008 10:11:48 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-ID: <20080121101147.GB2785@srcf.ucam.org>
References: <4793C5CA.5060100@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4793C5CA.5060100@wpkg.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: PROBLEM: Celeron Core
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2008 at 11:06:02PM +0100, Tomasz Chmielewski wrote:

> Aren't you forgetting about CPUfreq governors? Which mean: use the 
> maximum CPU frequency when the system is busy, throttle down (or lower 
> voltage) when the system is idle.
> 
> So yes, throttling will save the battery.
> 
> Besides, not all CPUs support power management (voltage control).

Voltage scaling isn't the only component of CPU power management. Intels 
have supported low power states on idle since the Pentium 90 (Cyrix had 
"Suspend on HALT" earlier than that), which means that an idle processor 
takes less power than one executing code. On anything even vaguely 
modern, throttling will not save you any significant power compared to 
the C state support.

> For example, a server that doesn't crunch any numbers at night will 
> certainly use less power when throttled.

Have you got benchmark figures for this?
-- 
Matthew Garrett | mjg59@srcf.ucam.org
