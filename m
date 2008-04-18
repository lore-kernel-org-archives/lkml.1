Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbYDRMLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbYDRMLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 08:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbYDRMLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 08:11:24 -0400
Received: from 82-69-137-158.dsl.in-addr.zen.co.uk ([82.69.137.158]:37206 "EHLO
	uklogin.uk.level5networks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752127AbYDRMLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 08:11:24 -0400
Date: Fri, 18 Apr 2008 13:10:17 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH][RFC] Add default CPU topology information
Message-ID: <20080418121016.GM21637@solarflare.com>
References: <20080331114412.GH21637@solarflare.com> <20080417234513.367c9ddc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417234513.367c9ddc.akpm@linux-foundation.org>
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
> 
> powerpc allmodconfig:
> 
> arch/powerpc/kernel/pci_64.c:655: error: expected identifier or '(' before 'void'
> arch/powerpc/kernel/pci_64.c:655: error: expected ')' before '(' token
<snip 
> gets it working, by tricking the preprocessor into expanding pcibus_to_node
> to itself, but it isn't exactly pleasing.

No, it isn't!  But cputopology.txt does say these should be macros, not
functions.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
