Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbYJQX24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbYJQX24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 19:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbYJQX2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 19:28:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbYJQX2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 19:28:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>, prasad@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <mingo@elte.hu>,
       <jason.wessel@windriver.com>, <avi@qumranet.com>,
       <richardj_moore@uk.ibm.com>
Subject: Re: [RFC Patch 3/9] Modifying generic debug exception to use virtual
 debug registers
In-Reply-To: Roland McGrath's message of  Friday, 17 October 2008 16:24:30 -0700 <20081017232430.9F48C1544CB@magilla.localdomain>
X-Fcc: ~/Mail/linus
References: <20081016192247.20F831542DA@magilla.localdomain>
	<Pine.LNX.4.44L0.0810171138510.2178-100000@iolanthe.rowland.org>
	<20081017232430.9F48C1544CB@magilla.localdomain>
X-Shopping-List: (1) Dynastic flotation consumers
   (2) Deviant abolitionists
   (3) Meteoritic miscreant pencils
Message-Id: <20081017232745.789551544CB@magilla.localdomain>
Date: Fri, 17 Oct 2008 16:27:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> kprobes stays as it, returns NOTIFY_STOP iff it's swallowing the step.

Oops, I think this breaks if there was also a ptrace db[0-3] hit in the
same exception.  In that case, kprobes would need to not return NOTIFY_STOP
when it otherwise would, if thread.vdr6 has low bits set.


Thanks,
Roland
