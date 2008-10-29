Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbYJ2TTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbYJ2TTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 15:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbYJ2TTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 15:19:00 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:58317 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbYJ2TS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 15:18:59 -0400
Date: Wed, 29 Oct 2008 14:18:55 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: sds@tycho.nsa.gov, jmorris@namei.org, chrisw@sous-sol.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       haradats@nttdata.co.jp, akpm@linux-foundation.org
Subject: Re: [TOMOYO #11 (linux-next) 00/11] TOMOYO Linux
Message-ID: <20081029191855.GA23612@us.ibm.com>
References: <20081020073423.024299308@nttdata.co.jp> <490524DA.1020705@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490524DA.1020705@nttdata.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kentaro Takeda (takedakn@nttdata.co.jp):
> Stephen, James, Chris, Serge,
> What is the status of this patchset?
> 
> I saw no objections against our patchset.

I don't like the 'in_exec' bit in the task_struct, but adding LSM hooks
to let just TOMOYO mark whether you're in exec seems even uglier.

> We are waiting for your review for now.
> Is there something we can do?

Well I think the patchset is at a stage where it needs a test-spin in
-mm (or something).

The users' list seems quite sparse, though.  Who exactly does use this,
and why?  (I don't mean that to sound adversarial, but while I think I
know how it differs from selinux, I'm not clear on when or why its
differences would be advantageous.)

-serge
