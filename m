Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbYHPCum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbYHPCum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 22:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYHPCud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 22:50:33 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:13992 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751860AbYHPCud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 22:50:33 -0400
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: sysprof in 2.6.27 kernel
References: <20080813083953.GF19333@ics.muni.cz>
	<ye8myjg7b4r.fsf@camel10.daimi.au.dk>
	<20080814111022.GC4674@ics.muni.cz>
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 16 Aug 2008 04:50:30 +0200
In-Reply-To: <20080814111022.GC4674@ics.muni.cz>
Message-ID: <ye84p5l7jwp.fsf@camel28.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek <xhejtman@ics.muni.cz> writes:

> On Thu, Aug 14, 2008 at 01:23:16AM +0200, Soeren Sandmann wrote:
> > It's somewhat rough still. If you try it out, I will be interested in
> > any feedback you have.
> 
> another feedback. I got No map at all processes even at those I got debug info
> installed.

This may be because sysprof user space is not running as root, or it
may be because the kernel is generating bogus addresses. 

Generally, "No Map" means sysprof is seeing samples in memory regions
that are not in /proc/<pid>/maps



Soren
