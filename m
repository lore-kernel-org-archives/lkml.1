Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbYG2W0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbYG2W0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbYG2W0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:26:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46943 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbYG2W0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:26:42 -0400
Subject: Re: Linux v2.6.27-rc1: problem with firmware stuff
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807291359110.3334@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org>
	 <200807292249.48050.rjw@sisk.pl> <200807292301.36987.rjw@sisk.pl>
	 <alpine.LFD.1.10.0807291359110.3334@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 23:26:37 +0100
Message-Id: <1217370397.27925.139.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 14:01 -0700, Linus Torvalds wrote:
> 
> On Tue, 29 Jul 2008, Rafael J. Wysocki wrote:
> > 
> > Actually, this happened due to some firmware files being created as root during
> > installations of pre-rc -git kernels from the O= directory.  So, not a real
> > problem, but somewhat confusing.
> 
> Yeah, I've had that happen myself. It used to be that "make 
> modules_install" (as root, obviously) would try build a new version of the 
> kernel, and as a result subsequent build attempts would fail horribly 
> because of various random files being now owned-by-root.
> 
> I don't know if there is a whole lot we can do about it in general..

Not in general. I _think_ I fixed the specific problem which led to
Rafael's situation, but I'm still waiting for confirmation of that.

-- 
dwmw2

