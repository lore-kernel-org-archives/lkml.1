Return-Path: <linux-kernel-owner+w=401wt.eu-S1752009AbXC3RXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbXC3RXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 13:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXC3RXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 13:23:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44211 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752009AbXC3RXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 13:23:11 -0400
Date: Fri, 30 Mar 2007 19:20:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: eranian@hpl.hp.com
Cc: linux-kernel@vger.kernel.org, perfmon@napali.hpl.hp.com
Subject: Re: exposing FSB clock speed in /sys
Message-ID: <20070330192053.36107276@the-village.bc.nu>
In-Reply-To: <20070330153937.GC16059@frankl.hpl.hp.com>
References: <20070330153937.GC16059@frankl.hpl.hp.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Looking at the code, it seems that there is no standard way of extracting
> the FSB speed. For each processor model, you have different MSRs. I would
> think that the routines in the cpufreq code could be moved out and used
> as the basis to expose the information somewhere in /sys.

It's well un-documented, but one of the problems is that for many
processor lines the information isn't in public documents (eg the older
processors like the PII/PIII)

Alan
