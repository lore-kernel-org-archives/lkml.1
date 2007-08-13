Return-Path: <linux-kernel-owner+w=401wt.eu-S946069AbXHMOBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946069AbXHMOBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S942467AbXHMKzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:55:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937073AbXHMKz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:55:27 -0400
Message-ID: <46C03885.7000109@redhat.com>
Date: Mon, 13 Aug 2007 06:55:01 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Segher Boessenkool <segher@kernel.crashing.org>,
       "Luck, Tony" <tony.luck@intel.com>, Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Chris Snook <csnook@redhat.com>
Subject: [PATCH 0/23] make atomic_read() and atomic_set() behavior consistent
 across all architectures
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

By popular demand, I've redone the patchset to include volatile casts in 
atomic_set as well.  I've also converted the macros to inline functions, to help 
catch type mismatches at compile time.

This will do weird things on ia64 without Andreas Schwab's fix:

http://lkml.org/lkml/2007/8/10/410

Notably absent is a patch for powerpc.  I expect Segher Boessenkool's assembly 
implementation should suffice there:

http://lkml.org/lkml/2007/8/10/470

Thanks to all who commented on previous incarnations.

	-- Chris Snook
