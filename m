Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab0BOWaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 17:30:15 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51297 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756609Ab0BOWaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 17:30:12 -0500
Date: Mon, 15 Feb 2010 22:28:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 6/9 v2] oom: deprecate oom_adj tunable
Message-ID: <20100215222845.0b0f2781@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.2.00.1002151418560.26927@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002151418560.26927@chino.kir.corp.google.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Feb 2010 14:20:16 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> /proc/pid/oom_adj is now deprecated so that that it may eventually be
> removed.  The target date for removal is December 2011.

There are systems that rely on this feature. It's ABI, its sacred. We are
committed to it and it has users. That doesn't really detract from the
good/bad of the rest of the proposal, it's just one step we can't quite
make.

Alan
