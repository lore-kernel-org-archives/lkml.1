Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbYDRMZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbYDRMZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 08:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYDRMZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 08:25:29 -0400
Received: from 82-69-137-158.dsl.in-addr.zen.co.uk ([82.69.137.158]:37230 "EHLO
	uklogin.uk.level5networks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752697AbYDRMZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 08:25:28 -0400
Date: Fri, 18 Apr 2008 13:24:28 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] Add default CPU topology information
Message-ID: <20080418122427.GN21637@solarflare.com>
References: <20080331114412.GH21637@solarflare.com> <20080418001024.7377c52d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418001024.7377c52d.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 31 Mar 2008 12:44:13 +0100 Ben Hutchings <bhutchings@solarflare.com> wrote:
> 
> > Not all architectures and configurations define CPU topology information.
> > This can result in an empty topology directory in sysfs, and requires
> > in-kernel users to protect all uses with #ifdef - see
> > <http://marc.info/?l=linux-netdev&m=120639033904472&w=2>.
> > 
> > The documentation of CPU topology specifies what the defaults should be
> > if only partial information is available from the hardware.  So we can
> > provide these defaults as a fallback.
> > 
> > This patch:
> > 
> > - Adds default definitions of the 4 topology macros to
> >   include/asm-generic/topology.h.
> > - Changes include/asm-*/topology.h to include <asm-generic/topology.h>
> >   unconditionally.
> > - Changes drivers/base/topology.c to use the topology macros unconditionally
> >   and to cope with definitions that aren't lvalues.
> > - Updates documentation accordingly.
> 
> I get a huuuuuuuge crash early in boot on the t61p dual x86_64 laptop. 
> Before netconsole has started and it has no serial port, so all I have is a
> partially-scrolled-off jpg, sorry.
>
> I'll drop the patch.
<snip>

Damn, x86 is also using functions instead of macros.  Sorry about that; I'll
have another try.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
