Return-Path: <linux-kernel-owner+w=401wt.eu-S1759774AbYDASVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774AbYDASVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 14:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758029AbYDASUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 14:20:54 -0400
Received: from mga06.intel.com ([134.134.136.21]:3019 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756507AbYDASUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 14:20:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,588,1199692800"; 
   d="scan'208";a="266365847"
Message-ID: <47F27D05.5000108@linux.intel.com>
Date: Tue, 01 Apr 2008 11:20:53 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Dave Airlie <airlied@redhat.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       thomas@tungstengraphics.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com>
In-Reply-To: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> When cpa was refactored to the new set_memory_ interfaces, it removed
> a special case fast path for AGP systems, which did a lot of page by page
> attribute changing and held the flushes until they were finished. The
> DRM memory manager also required this to get useable speeds.
> 
> This introduces a new interface, which accepts an array of memory addresses
> to have attributes changed on and to flush once finished.
> 
> Further changes to the AGP stack to actually use this interface will be
> published later.

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
