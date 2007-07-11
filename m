Return-Path: <linux-kernel-owner+w=401wt.eu-S1763787AbXGKQbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763787AbXGKQbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 12:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755311AbXGKQbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 12:31:46 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:50492 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754952AbXGKQbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 12:31:45 -0400
Date: Thu, 12 Jul 2007 01:31:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       linux-sh <linuxsh-dev@lists.sourceforge.net>
Subject: Re: [PATCH -rc7][resend
Message-ID: <20070711163140.GF7667@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Satyam Sharma <ssatyam@cse.iitk.ac.in>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	linux-sh <linuxsh-dev@lists.sourceforge.net>
References: <20070707164558.1333.35999.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070707164558.1333.35999.sendpatchset@cselinux1.cse.iitk.ac.in>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2007 at 10:15:58PM +0530, Satyam Sharma wrote:
> sh_machine_vector structures throughout arch/sh/boards/ are marked
> __initmv so that they go to the .machvec.init section, when SH_GENERIC ||
> SH_UNKNOWN. But when !SH_GENERIC && !SH_UNKNOWN, __initmv is not defined,
> so all the machine vector structures go to the .data section. But, all
> the .mv_setup members of various sh_machine_vector structures throughout
> the arch/sh/boards/ directory are set to point to functions that are
> marked as __init unconditionally.
> 
Already fixed in my current git tree.
