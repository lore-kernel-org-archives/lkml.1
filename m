Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbYFTAFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbYFTAFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 20:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYFTAFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 20:05:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:41392 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbYFTAFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 20:05:23 -0400
Date: Thu, 19 Jun 2008 17:05:12 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Ryan Hope" <rmh3093@gmail.com>
Cc: linux-mm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Lockless patches cause hardlock under heavy IO
Message-ID: <20080619170512.6ef5cd3a@infradead.org>
In-Reply-To: <48f7fe350806190745u1b78ae61ue8e71619db5756f7@mail.gmail.com>
References: <48f7fe350806181415l4eba61b3i1d206de03147575e@mail.gmail.com>
	<20080618142849.13e90c6d@infradead.org>
	<48f7fe350806190745u1b78ae61ue8e71619db5756f7@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2008 10:45:43 -0400
"Ryan Hope" <rmh3093@gmail.com> wrote:

> Well enabling these debug options is sorta useless because once it
> hardlocks I cant see or do anything..
> 

the nice thing about lockdep is that it spots *potential* deadlocks;
often well before the actual deadlock happens...



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
