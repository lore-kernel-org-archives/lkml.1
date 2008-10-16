Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbYJPBpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbYJPBpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 21:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYJPBpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 21:45:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbYJPBpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 21:45:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: prasad@linux.vnet.ibm.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, akpm@linux-foundation.org,
       mingo@elte.hu, jason.wessel@windriver.com, avi@qumranet.com,
       richardj_moore@uk.ibm.com
Subject: Re: [RFC Patch 8/9] Modify Ptrace to use wrapper routines to access
	breakpoint registers
In-Reply-To: K.Prasad's message of  Thursday, 9 October 2008 00:56:37 +0530 <20081008192637.GH4989@in.ibm.com>
References: <20081008192044.GA4510@in.ibm.com>
	<20081008192637.GH4989@in.ibm.com>
X-Fcc: ~/Mail/linus
X-Zippy-Says: Yow!  Am I JOGGING yet??
Message-Id: <20081016014446.374641544CB@magilla.localdomain>
Date: Wed, 15 Oct 2008 18:44:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just make the new functions in hw_breakpoint code use the same old ptrace_*
names.  Those are the proper names for this.  It really is just compatibility
for the old ptrace interface, not any other reason for "thread" debugregs.
Then this patch need do nothing but remove the static ptrace.c functions.


Thanks,
Roland

