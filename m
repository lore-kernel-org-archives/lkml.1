Return-Path: <linux-kernel-owner+w=401wt.eu-S1761488AbYD3M1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761488AbYD3M1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 08:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbYD3M13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 08:27:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752719AbYD3M13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:27:29 -0400
Date: Wed, 30 Apr 2008 05:26:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: andi-suse@firstfloor.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, mtk.manpages@gmail.com,
       eranian@googlemail.com, juan.villacis@intel.com
Subject: Re: [patch] x86, ptrace: in-kernel BTS interface
Message-Id: <20080430052631.3d182670.akpm@linux-foundation.org>
In-Reply-To: <20080430135440.A359@sedona.ch.intel.com>
References: <20080430135440.A359@sedona.ch.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 13:54:40 +0200 Markus Metzger <markus.t.metzger@intel.com> wrote:

> Provide an in-kernel interface to Branch Trace Store and implement the
> ptrace user interface on top of it.
> 
> Fix a few bugs that were detected during the perfmon2 adaptation to
> the DS interface by Stephane Eranian.
> 
> The ptrace implementation becomes a rather thin layer that only
> forwards requests.
> 
> The BTS interface may later be morphed into a utrace interface for
> execution trace, or it may be used to implement such a utrace
> interface on top of it.

This appears to be against a version of x86-ptrace-pebs-support
which I don't have.

I dropped everything - let's start again.
