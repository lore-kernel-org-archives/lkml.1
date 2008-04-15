Return-Path: <linux-kernel-owner+w=401wt.eu-S1764342AbYDOTnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764342AbYDOTnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 15:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757896AbYDOTmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 15:42:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759225AbYDOTmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 15:42:50 -0400
Date: Tue, 15 Apr 2008 12:42:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][RFC] Add default CPU topology information
Message-Id: <20080415124231.e22df79e.akpm@linux-foundation.org>
In-Reply-To: <20080331114412.GH21637@solarflare.com>
References: <20080331114412.GH21637@solarflare.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2008 12:44:13 +0100
Ben Hutchings <bhutchings@solarflare.com> wrote:

> Not all architectures and configurations define CPU topology information.
> This can result in an empty topology directory in sysfs, and requires
> in-kernel users to protect all uses with #ifdef - see
> <http://marc.info/?l=linux-netdev&m=120639033904472&w=2>.
> 
> The documentation of CPU topology specifies what the defaults should be
> if only partial information is available from the hardware.  So we can
> provide these defaults as a fallback.
> 
> This patch:
> 
> - Adds default definitions of the 4 topology macros to
>   include/asm-generic/topology.h.
> - Changes include/asm-*/topology.h to include <asm-generic/topology.h>
>   unconditionally.
> - Changes drivers/base/topology.c to use the topology macros unconditionally
>   and to cope with definitions that aren't lvalues.
> - Updates documentation accordingly.
> 

I ran away in terror when I saw this patch.  It's dark and dirty stuff
you're unearthing there and it looks like a minefield of compilation
problems.  Not aided by the fact that we don't have a topology maintainer
afaik.  

We shall see.

