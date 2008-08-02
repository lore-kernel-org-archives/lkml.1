Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbYHBScT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbYHBScT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 14:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbYHBScJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 14:32:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:34339 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbYHBScI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 14:32:08 -0400
Date: Sat, 2 Aug 2008 11:32:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: rankincj@yahoo.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Enabling PAT in 2.6.26.x
Message-ID: <20080802113205.18f67d50@infradead.org>
In-Reply-To: <143234.6160.qm@web52907.mail.re2.yahoo.com>
References: <143234.6160.qm@web52907.mail.re2.yahoo.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Aug 2008 11:16:35 -0700 (PDT)
Chris Rankin <rankincj@yahoo.com> wrote:

> Hi,
> 
> I see that the PAT support in 2.6.26.x depends on the CPUID
> information, and that it is currently disabled for some older model
> Pentium IIIs:
> 
> 
> I suppose that I could hack the kernel to allow PAT to be enabled for
> this model CPU, but I'm not sure how meaningful the results would be.
> Does PAT support either work immediately or not at all? Or are any
> errors likely to be more subtle?

errors are a LOT more subtle sadly, things like "once every month a
spontaneous reboot happens"

> 
> Basically, is there any reliable way of confirming whether PAT can be
> enabled for the CPU, please?

It'll come down to someone reading the CPU errata sheet to see if
there's known issues.

For Intel cpus.... I'll nominate Venki for this (he already did this
for many models)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
