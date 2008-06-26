Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYFZA1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYFZA1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 20:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYFZA1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 20:27:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55196 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbYFZA1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 20:27:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>, kernel-testers@vger.kernel.org
Subject: Re: linux-next: Tree for June 25
Date: Thu, 26 Jun 2008 02:28:38 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080626003554.b2623aba.sfr@canb.auug.org.au>
In-Reply-To: <20080626003554.b2623aba.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806260228.38674.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 25 of June 2008, Stephen Rothwell wrote:
> Hi all,

Hi,

> Changes since next-20080624:
> 
> The tip-core tree gained three conflicts against Linus' tree.
> 
> The sched tree gained a conflict against the cpus4096 tree.
> 
> The x86 tree gained a conflict against the ftrace tree.  It also required
> three patches that Ingo supplied.
> 
> The pci tree gained two conflicts against the x86 tree.
> 
> The v4l-dvb tree has had another commit reverted for a build problem,
> however that may have been due to a mismerge in yesterday's tree.
> 
> The acpi tree gained two conflicts against the x86 tree.
> 
> The tests tree gained a conflict against the sched tree.
> 
> The vfs tree gained a conflict against the sched tree.
> 
> The rr tree gained a conflict against each of the sched and powerpc
> trees.  It also required a patch and a commit reverted for build problems.
> 
> The pcmcia tree lost its conflict against Linus' tree.

This tree is completely broken on my test box (x86-64 HP nx6325) and I can't
even bisect it. :-(

It hits a NULL pointer dereference in find_symbol during boot, but when I tried
to bisect this issue, I hit another one that made the box hang solid during
boot (early, no messages available).

If things continue going this way, 2.6.27 will be a disaster ...

Thanks,
Rafael
