Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab0CIUVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 15:21:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494Ab0CIUVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 15:21:08 -0500
Date: Tue, 9 Mar 2010 12:19:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: mm: Do not iterate over NR_CPUS in __zone_pcp_update()
Message-Id: <20100309121953.4413db85.akpm@linux-foundation.org>
In-Reply-To: <4B96A9B2.8070806@cs.helsinki.fi>
References: <alpine.LFD.2.00.1003081018070.22855@localhost.localdomain>
	<84144f021003080529w1b20c08dmf6871bd46381bc71@mail.gmail.com>
	<4B95AD17.2030106@kernel.org>
	<alpine.DEB.2.00.1003090910200.28897@router.home>
	<4B96A9B2.8070806@cs.helsinki.fi>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Mar 2010 22:04:02 +0200
Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Christoph Lameter wrote:
> > On Tue, 9 Mar 2010, Tejun Heo wrote:
> > 
> >> Yeap, that's buggy.
> >>
> >> Acked-by: Tejun Heo <tj@kernel.org>
> >>
> >> I suppose this would go through the mm tree?
> > 
> > As you said: Its a bug so it needs to be applied to upstream.
> 
> Sure but someone needs to pick up the patch and send it to Linus. Andrew?
> 

yup, I found the patch.
