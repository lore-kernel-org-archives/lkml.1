Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbYHHKmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbYHHKmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 06:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYHHKmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 06:42:45 -0400
Received: from sender-03.it.helsinki.fi ([128.214.205.141]:48007 "EHLO
	sender-03.it.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbYHHKmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 06:42:45 -0400
X-Greylist: delayed 2003 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Aug 2008 06:42:44 EDT
Date: Fri, 8 Aug 2008 13:09:06 +0300 (EEST)
From: Vesa-Matti J Kari <vmkari@cc.helsinki.fi>
X-X-Sender: vmkari@ruuvi.it.helsinki.fi
To: James Morris <jmorris@namei.org>
cc: sds@tycho.nsa.gov, eparis@parisplace.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov
Subject: Re: [PATCH] selinux: conditional expression type validation was
 off-by-one
In-Reply-To: <alpine.LRH.1.10.0808070945400.15561@tundra.namei.org>
Message-ID: <Pine.LNX.4.64L.0808081307500.24884@ruuvi.it.helsinki.fi>
References: <200808061546.m76Fkwq1005199@ruuvi.it.helsinki.fi>
 <alpine.LRH.1.10.0808070945400.15561@tundra.namei.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

On Thu, 7 Aug 2008, James Morris wrote:

> On Wed, 6 Aug 2008, Vesa-Matti Kari wrote:
>
> > expr_isvalid() in conditional.c was off-by-one and allowed
> > invalid expression type COND_LAST. However, it is this header file
> > that needs to be fixed. That way the if-statement's disjunction's
> > second component reads more naturally, "if expr type is greater than
> > the last allowed value" ( rather than using ">=" in conditional.c):
> >
> >   if (expr->expr_type <= 0 || expr->expr_type > COND_LAST)
> >
> > Signed-off-by: Vesa-Matti Kari <vmkari@cc.helsinki.fi>
>
> Thanks, nice catch.
>
> Applied to
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

I also checked out the userspace and the same bug exists in libsepol.

Best regards,
vmk
-- 
************************************************************************
               Tietotekniikkaosasto / Helsingin yliopisto
                 IT Department / University of Helsinki
************************************************************************
