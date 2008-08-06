Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbYHGAEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbYHGAEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 20:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbYHFXru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 19:47:50 -0400
Received: from tundra.namei.org ([65.99.196.166]:49677 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbYHFXrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 19:47:49 -0400
Date: Thu, 7 Aug 2008 09:47:23 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Vesa-Matti Kari <vmkari@cc.helsinki.fi>
cc: sds@tycho.nsa.gov, eparis@parisplace.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov
Subject: Re: [PATCH] selinux: conditional expression type validation was
 off-by-one
In-Reply-To: <200808061546.m76Fkwq1005199@ruuvi.it.helsinki.fi>
Message-ID: <alpine.LRH.1.10.0808070945400.15561@tundra.namei.org>
References: <200808061546.m76Fkwq1005199@ruuvi.it.helsinki.fi>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008, Vesa-Matti Kari wrote:

> expr_isvalid() in conditional.c was off-by-one and allowed
> invalid expression type COND_LAST. However, it is this header file
> that needs to be fixed. That way the if-statement's disjunction's
> second component reads more naturally, "if expr type is greater than
> the last allowed value" ( rather than using ">=" in conditional.c):
> 
>   if (expr->expr_type <= 0 || expr->expr_type > COND_LAST)
> 
> Signed-off-by: Vesa-Matti Kari <vmkari@cc.helsinki.fi>

Thanks, nice catch.

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next



- James
-- 
James Morris
<jmorris@namei.org>
