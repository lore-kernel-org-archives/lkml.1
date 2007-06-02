Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbXFBCSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbXFBCSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 22:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbXFBCRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 22:17:55 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56145 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbXFBCRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 22:17:54 -0400
Date: Fri, 1 Jun 2007 19:19:07 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Emmanuel Fust? <emmanuel.fuste@laposte.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070602021906.GC13751@tree.beaverton.ibm.com>
References: <JIZ905$469B6EF277FE655A66C9ACE2321FC036@laposte.net> <m1sl9bxl7r.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1sl9bxl7r.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 06:18:32PM -0600, Eric W. Biederman wrote:

> I doubt it.  The practical problem is that cpu_down does not
> and by design can not call the irq balancing part properly
> and I haven't yet seen anything to suggest that we don't migrate
> irq properly.
> 
> So I'm guessing it was the decision part.

I'm not using any IRQ balancer, afaik.  As I recall, CONFIG_IRQBALANCE
is i386-only, and I'm not running the userland irqbalance program
either.  Just messing around with /proc/irq/*/smp_affinity by hand. :)

--D
