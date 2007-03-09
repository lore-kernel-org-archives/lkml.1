Return-Path: <linux-kernel-owner+w=401wt.eu-S1767421AbXCIRVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767421AbXCIRVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 12:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767429AbXCIRVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 12:21:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41119 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767421AbXCIRVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 12:21:14 -0500
Subject: Re: [PATCH] Complain about missing system calls.
From: David Woodhouse <dwmw2@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       rmk@arm.linux.org.uk, sam@ravnborg.org, linux-arch@vger.kernel.org
In-Reply-To: <p737itqbdnl.fsf@bingen.suse.de>
References: <1173394873.3461.510.camel@pmac.infradead.org>
	 <p737itqbdnl.fsf@bingen.suse.de>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 17:20:02 +0000
Message-Id: <1173460802.12760.2.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-09 at 17:11 +0100, Andi Kleen wrote:
> Of course the existing syscall numbers can't be changed, but for all new 
> calls one could just add automatically for everybody.
> 
> A global table with two entries (compat and non compat) and a per arch 
> override table should be sufficient.

Counterexample: sys_epoll_pwait.

It'd be nice if it were that simple.

It'd also be nice if people stopped thinking it was that simple :)

-- 
dwmw2

