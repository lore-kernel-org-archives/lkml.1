Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbYFCUDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbYFCUDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 16:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbYFCUDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 16:03:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754819AbYFCUDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 16:03:07 -0400
Date: Tue, 3 Jun 2008 13:02:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] cputopology: Add default CPU topology information [3rd
 try]
Message-Id: <20080603130222.694c5675.akpm@linux-foundation.org>
In-Reply-To: <20080531214429.GQ1743@solarflare.com>
References: <20080531214429.GQ1743@solarflare.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2008 22:44:30 +0100
Ben Hutchings <bhutchings@solarflare.com> wrote:

> Define the macros topology_{physical_package,core}_id() and
> topology_{thread,core}_siblings() in <asm-generic/topology.h> if they are not
> already defined.
> 
> Move inclusion of <asm-generic/topology.h> after definitions of these
> macros in <asm-powerpc/topology.h> and <asm-x86/topology.h>.
> 
> Change drivers/base/topology.c to use the topology macros unconditionally and
> to cope with definitions that aren't lvalues.

Can you please redo this against linux-next?

That tree contains a number of directly conflicting changes.  In
particular, linux-next introduces alternate implementations of
show_##name and show_##name##_list in topology.c and from a quick peek,
your change could make them go away again.

Please also enhance the changelog so we have some idea of why you're
actually doing all this.  What do we gain?  Does it fix a bug?  If so,
what?  etc.

Thanks.
