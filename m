Return-Path: <linux-kernel-owner+w=401wt.eu-S933219AbXBBEZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbXBBEZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 23:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933232AbXBBEZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 23:25:52 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60164 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933219AbXBBEZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 23:25:51 -0500
Date: Thu, 1 Feb 2007 20:22:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: jbohac@suse.cz
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: Re: [patch 0/9] x86_64: reliable TSC-based gettimeofday
Message-Id: <20070201202213.c7726d68.akpm@linux-foundation.org>
In-Reply-To: <20070201095952.589234000@jet.suse.cz>
References: <20070201095952.589234000@jet.suse.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Feb 2007 10:59:52 +0100 jbohac@suse.cz wrote:

> TSC-based x86_64 timekeeping implementation

I worry about the relationship between this work and all the time-management
changes in -mm.  If Andi to were to merge all this stuff under that then I
expect various catastrophes would ensue.

Have you checked to determine the severity of the overlaps?
