Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbYDUCfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbYDUCfc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 22:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbYDUCfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 22:35:22 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:28759 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYDUCfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 22:35:22 -0400
Date: Sun, 20 Apr 2008 19:35:17 -0700 (PDT)
From: Dave Olson <dave.olson@qlogic.com>
To: Roland Dreier <rdreier@cisco.com>
cc: Ingo Molnar <mingo@elte.hu>, Ralph Campbell <ralph.campbell@qlogic.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [GIT PULL] please pull infiniband.git
In-Reply-To: <aday7789dkk.fsf@cisco.com>
Message-ID: <alpine.LFD.1.00.0804201933560.11455@topaz.pathscale.com>
References: <adaskxkh6s2.fsf@cisco.com> <20080419081614.GA2437@elte.hu> <adaod86aq9j.fsf@cisco.com> <alpine.LFD.1.00.0804190817280.21302@topaz.pathscale.com> <adafxthbz8p.fsf@cisco.com> <alpine.LFD.1.00.0804200746310.6811@topaz.pathscale.com>
 <aday7789dkk.fsf@cisco.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 21 Apr 2008 02:35:21.0538 (UTC) FILETIME=[5862D220:01C8A358]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2008, Roland Dreier wrote:
|  > | so clearly ipath_init_iba7220_funcs() was intended to be built and used
|  > | even if CONFIG_PCI_MSI was not defined.  From the code it looks like all
|  > | should work fine if PCI_MSI is not set, so I don't know what you mean
|  > | about conditional checks.
|  > 
|  > Actually, it wasn't.  It was a late cleanup for another problem, and
|  > we didn't worry about the other issue, and should have.
| 
| Sorry, I still don't follow.  What is the antecedent of "it"?  What was
| "the other issue"?

The CONFIG_PCI_MSI check where init_iba7220 is called.

| I'm not sure I know the right fix for the build breakage.  It seems
| there are two possibilities:
| 
|  - build the iba7220 support unconditionally (the patch I posted).

Yep; I already said I was OK with that.  It's simplest, let's go with it.

| And given that at least some device support works even if neither
| PCI_MSI nor HT_IRQ is defined, then it makes sense to me to remove that
| Kconfig dependency.

Go ahead.

Dave Olson
dave.olson@qlogic.com
