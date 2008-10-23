Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbYJWBHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbYJWBHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 21:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbYJWBHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 21:07:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:37909 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbYJWBHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 21:07:23 -0400
Date: Wed, 22 Oct 2008 18:07:37 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Tony Luck" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] get rid if __cpuinit and __cpuexit
Message-ID: <20081022180737.289ab7ee@infradead.org>
In-Reply-To: <12c511ca0810221712n665b4c75t5d07c7f4d5e006b2@mail.gmail.com>
References: <20081022153054.335ce51e@infradead.org>
	<12c511ca0810221712n665b4c75t5d07c7f4d5e006b2@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 17:12:14 -0700
"Tony Luck" <tony.luck@intel.com> wrote:

> On Wed, Oct 22, 2008 at 3:30 PM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> > as discussed briefly at the kernel summit; __cpuinit and __cpuexit
> > are causing a ton more complexity than they're worth (just see how
> > many section warnings an average build has);
> 
> Nice idea ... but on ia64 I actually see *more* section mismatch
> warnings with this patch applied :-(
> 
> generic_defconfig goes up from 6 to 7
> tiger_defconfig rises from 3 to 6

interesting... I don't see how that can be unless the checks originally
had a bug and did not complain about a reference to __init(data) memory
from inside __cpuinit memory...
(in which case my point of this being too complex and fragile is
proven ;-)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
