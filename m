Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166Ab0ANLJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab0ANLJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 06:09:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216Ab0ANLJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 06:09:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:57631 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213Ab0ANLJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 06:09:00 -0500
Subject: Re: [RFC] [PATCH 3/7] Execution out of line (XOL)
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100111122545.22050.64994.sendpatchset@srikar.in.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122545.22050.64994.sendpatchset@srikar.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 12:08:38 +0100
Message-ID: <1263467318.4244.289.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 17:55 +0530, Srikar Dronamraju wrote:
> Execution out of line (XOL)
> 
> Slot allocation mechanism for Execution Out of Line strategy in User
> space breakpointing Inftrastructure. (XOL)
> 
> This patch provides slot allocation mechanism for execution out of
> line strategy for use with user space breakpoint infrastructure.
> This patch requires utrace support in kernel.
> 
> This patch provides five functions xol_get_insn_slot(),
> xol_free_insn_slot(), xol_put_area(), xol_get_area() and
> xol_validate_vaddr().
> 
> Current slot allocation mechanism:
> 1. Allocate one dedicated slot per user breakpoint.
> 2. If the allocated vma is completely used, expand current vma.
> 3. If we cant expand the vma, allocate a new vma.


Say what?

I see the text, but non of it makes any sense at all.

