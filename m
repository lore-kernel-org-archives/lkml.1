Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776Ab0AXHTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab0AXHTt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 02:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663Ab0AXHTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 02:19:49 -0500
Received: from mail.gmx.net ([213.165.64.20]:44206 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751164Ab0AXHTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 02:19:48 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/tXXhZGUvt4Uylkc2oUw0LboiMHW8zBqkI+j/yjr
	db0AGlfl6Pna73
Subject: Re: Bisected rcu hang (kernel/sched.c): was 2.6.33rc4 RCU hang mm
 spin_lock deadlock(?) after running libvirtd - reproducible.
From: Mike Galbraith <efault@gmx.de>
To: Michael Breuer <mbreuer@majjas.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4B5BE96A.8000304@majjas.com>
References: <4B49015D.9000903@majjas.com> <4B4A341B.6010800@majjas.com>
	 <20100112014909.GB10869@linux.vnet.ibm.com> <4B4E1461.4010806@majjas.com>
	 <4B5BB535.8040200@majjas.com> <1264312795.5904.13.camel@marge.simson.net>
	 <4B5BE96A.8000304@majjas.com>
Content-Type: text/plain
Date: Sun, 24 Jan 2010 08:19:44 +0100
Message-Id: <1264317584.6446.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67000000000000004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-24 at 01:32 -0500, Michael Breuer wrote:

> That commit solves my crash. Was my first time bisecting... thought I 
> got it right. With the referenced commit, the system crashed when 
> libvirtd was started, at the previous commit, it didn't crash. 
> Regardless, the commit in tip fixes the issue. Hopefully it'll solve 
> some of the other reported RCU hangs as well. Looks like the change for 
> freshly cloned tasks is key.

Great, and yeah, the freshly cloned bit is the fix for your scenario.

	-Mike

