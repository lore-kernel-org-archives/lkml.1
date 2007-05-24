Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbXEXIRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbXEXIRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 04:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbXEXIRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 04:17:00 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755952AbXEXIQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 04:16:59 -0400
Date: Thu, 24 May 2007 01:15:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: righiandr@users.sourceforge.net, Bernd Eckenfels <ecki@lina.inka.de>,
       linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
       linux-mm@kvack.org
Subject: Re: [PATCH 1/2] limit print_fatal_signal() rate (was: [RFC] log
 out-of-virtual-memory events)
Message-Id: <20070524011551.3d72a6e8.akpm@linux-foundation.org>
In-Reply-To: <20070524075835.GC21138@elte.hu>
References: <E1Hp5PV-0001Bn-00@calista.eckenfels.net>
	<464ED258.2010903@users.sourceforge.net>
	<20070520203123.5cde3224.akpm@linux-foundation.org>
	<20070524075835.GC21138@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 09:58:35 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Well OK.  But vdso-print-fatal-signals.patch is designated 
> > not-for-mainline anyway.
> 
> btw., why?

err, because that's what I decided a year ago.  I wonder why ;)

Perhaps because of the DoS thing, but it has a /proc knob and defaults to
off, so it should be OK.

> It's very, very useful to distro, early-boot-userspace and 
> glibc development. The only add-on change should be to not print SIGKILL 
> events. Otherwise it's very much a keeper. Hm?
> 

<promotes it>
