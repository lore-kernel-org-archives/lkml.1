Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbYB2Kjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbYB2Kjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 05:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756154AbYB2KjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 05:39:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47111 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951AbYB2KjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 05:39:12 -0500
Subject: Re: [patch 2/2] sched: allow cpuacct stats to be reset
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Menage <menage@google.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, vatsa@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, skumar@linux.vnet.ibm.com
In-Reply-To: <6599ad830802290208l6b9d97d1l67e351fc2f9112f7@mail.gmail.com>
References: <20080229043242.110741439@linux.vnet.ibm.com>
	 <20080229043751.555866685@linux.vnet.ibm.com>
	 <6599ad830802282148g7f309995l450fc15074234cd7@mail.gmail.com>
	 <20080229060435.GB5478@linux.vnet.ibm.com>
	 <6599ad830802290208l6b9d97d1l67e351fc2f9112f7@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 11:38:54 +0100
Message-Id: <1204281534.6243.75.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 02:08 -0800, Paul Menage wrote:
> On Thu, Feb 28, 2008 at 10:04 PM, Dhaval Giani
> <dhaval@linux.vnet.ibm.com> wrote:
> > On Thu, Feb 28, 2008 at 09:48:51PM -0800, Paul Menage wrote:
> >
> > > On Thu, Feb 28, 2008 at 8:32 PM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> >  >
> >
> > > Can I suggest, in order to be more generic, that this patch instead
> >  > set each CPU's counter to the written value divided by the number of
> >  > CPUs? (Either forgetting the remainder, or spreading it among the
> >  > first few CPUs).
> >  >
> >
> >  This patch is only allowing a reset of the stats. In what sort of a
> >  situation would one be looking for changing the usage value?
> 
> How about Checkpoint/Restart?

Shouldn't that be a kernel side thing? And from the kernel you can put
back any value you fancy.

