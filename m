Return-Path: <linux-kernel-owner+w=401wt.eu-S933855AbXC2AKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855AbXC2AKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 20:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933896AbXC2AKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 20:10:54 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36361 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933855AbXC2AKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 20:10:53 -0400
Date: Wed, 28 Mar 2007 17:10:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: Blaisorblade <blaisorblade@yahoo.it>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 0/4] UML - Code cleanups for 2.6.21
Message-Id: <20070328171046.fb56ae75.akpm@linux-foundation.org>
In-Reply-To: <20070328152845.GA6350@c2.user-mode-linux.org>
References: <20070328152845.GA6350@c2.user-mode-linux.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007 11:28:45 -0400
Jeff Dike <jdike@addtoit.com> wrote:

> These are tidying patches from Blaisorblade - 2.6.21 material.

The three net_kern.c patches invoked a reject storm against mainline,
presumably because of uml-network-interface-hotplug-error-handling.patch.

So I bumped those three patches into 2.6.22.
