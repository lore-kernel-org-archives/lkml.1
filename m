Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbZBGHvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbZBGHvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 02:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbZBGHvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 02:51:01 -0500
Received: from ozlabs.org ([203.10.76.45]:33705 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbZBGHvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 02:51:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/3] cpumask: fix powernow-k8: partial revert of 2fdf66b491ac706657946442789ec644cc317e1a
Date: Sat, 7 Feb 2009 18:20:49 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200902071809.39175.rusty@rustcorp.com.au> <498D3C01.1050307@kernel.org>
In-Reply-To: <498D3C01.1050307@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902071820.50212.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 February 2009 18:15:05 Yinghai Lu wrote:
> Rusty Russell wrote:
> > Impact: fix powernow-k8 when acpi=off (or other error).
> > 
> > There was a spurious change introduced into powernow-k8 in this patch:
> > the cause if that we try to "restore" the cpus_allowed we never saved.
> > 
> > See lkml "[PATCH] x86/powernow: fix cpus_allowed brokage when
> > acpi=off" from Yinghai for the bug report.
> > 
> 
> and
> 
> [PATCH] x86/powernow: dont emit warning when acpi=off

To be clear, is this for 2.6.29, or can wait for .30?  The three I sent are
needed for 2.6.29 I think.

Thanks,
Rusty.
