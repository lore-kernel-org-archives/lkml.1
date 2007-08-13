Return-Path: <linux-kernel-owner+w=401wt.eu-S1031619AbXHMRbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031619AbXHMRbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S973640AbXHMR1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:27:40 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:30405 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S973668AbXHMR1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:27:18 -0400
X-IronPort-AV: i="4.19,255,1183359600"; 
   d="scan'208"; a="170724293:sNHT44510616"
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, surya.prabhakar@wipro.com,
       mingo@redhat.com, yaku@css1.kbnes.nec.co.jp,
       kisimoto@css1.kbnes.nec.co.jp, zab@redhat.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [KJ] replacing kmalloc with kzalloc in io_apic.c
X-Message-Flag: Warning: May contain useful information
References: <1186993881.3175.15.camel@bluegenie>
	<200708131518.20580.m.kozlowski@tuxland.pl>
	<Pine.LNX.4.64.0708131153190.4382@localhost.localdomain>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 13 Aug 2007 10:27:07 -0700
In-Reply-To: <Pine.LNX.4.64.0708131153190.4382@localhost.localdomain> (Robert P. J. Day's message of "Mon, 13 Aug 2007 11:54:42 -0400 (EDT)")
Message-ID: <aday7gf8hw4.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Aug 2007 17:27:07.0780 (UTC) FILETIME=[2C7E6C40:01C7DDCF]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > from my days submitting numerous patches of this type, i can recall
 > that in cases like the above, it's a judgment call -- use kzalloc to
 > get the zeroing, or use kcalloc to get the array-flavoured behaviour.
 > what a shame you can't have both at the same time.

kcalloc() zeros memory just like standard calloc() in userspace.

As <linux/slab.h> says:

 * kcalloc - allocate memory for an array. The memory is set to zero.
