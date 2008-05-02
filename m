Return-Path: <linux-kernel-owner+w=401wt.eu-S1762859AbYEBGvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762859AbYEBGvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 02:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756316AbYEBGvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 02:51:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:38911 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755991AbYEBGvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 02:51:04 -0400
X-Authenticated: #429267
X-Provags-ID: V01U2FsdGVkX19im+V7ePdif0wf2lHk+BiOvM4FFD4/VcpQJV8qYA
	vgIsjspRhrqUp2
Subject: Re: [PATCH] fix irq flags in mac80211 code
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@osdl.org
In-Reply-To: <Pine.LNX.4.58.0805011847090.12785@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805011847090.12785@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Fri, 02 May 2008 08:50:56 +0200
Message-Id: <1209711056.5503.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 18:48 -0400, Steven Rostedt wrote:
> A file in the net/mac80211 directory uses "int" for flags. This can
> cause hard to find bugs on some architectures. This patch converts the
> flags to use "long" instead.
> 
> This bug was discovered by doing an allyesconfig make on the -rt kernel
> where checks are done to ensure all flags are of size sizeof(long).

Good catch, thanks.

Mattias

