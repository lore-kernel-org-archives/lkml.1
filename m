Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbXKTW7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbXKTW7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXKTW65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:58:57 -0500
Received: from main.gmane.org ([80.91.229.2]:38341 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbXKTW64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:58:56 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Helge Deller <deller@gmx.de>
Subject: RE: [PATCH] Time-based RFC 4122 UUID generator
Date: Tue, 20 Nov 2007 23:58:38 +0100
Message-ID: <fhvoqu$u6l$1@ger.gmane.org>
References: <fhqbkn$ttt$1@ger.gmane.org> <MDEHLPKNGKAHNMBLJOLKCECCIFAC.davids@webmaster.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: mnhm-590df471.pool.einsundeins.de
User-Agent: KNode/0.10.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:
> Any UUID generator that can produce duplicate UUIDs with probability
> significantly less than purely random UUIDs is so badly broken that it
> should not ever be used. Anyone who finds such a UUID generator should
> immediately either fix it or throw it on the junk heap. 

That's what my patch is about: Solve the problem at it's root.

> Anyone who 
> knowingly uses such a UUID generator should be publically shamed.

The problem is that on Linux there is currently no time-based UUID generator
which really solves the problem.
Good (bad?) thing is: Other UNIXes aren't better either.

> Rather than (or at the very least, in addition to) adding a new UUID
> generator, let's fix the one(s) we have.

Some things aren't fixable with userspace only. At least _some_ kind of help
is needed from the kernel.
Why not providing one single working version directly from the kernel and
dropping others you can't cleanly fix anyway ?

Helge

