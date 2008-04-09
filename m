Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbYDILpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbYDILpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 07:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbYDILpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 07:45:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36491 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbYDILpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 07:45:39 -0400
Subject: Re: [PATCH 1/2] HAVE_SET_RESTORE_SIGMASK
From: David Woodhouse <dwmw2@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: "Linus Torvalds <torvalds@linux-foundation.org>Andrew Morton" 
	<akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, miles@gnu.org,
       rmk+linux@arm.linux.org.uk, geert@linux-m68k.org, zippel@linux-m68k.org
In-Reply-To: <20080329031146.6FF7126FA1D@magilla.localdomain>
References: <20080329001230.D013726FA1D@magilla.localdomain>
	 <20080329001341.7F93826FA1D@magilla.localdomain>
	 <alpine.LFD.1.00.0803281746480.14670@woody.linux-foundation.org>
	 <20080329022408.0DD4726FA1D@magilla.localdomain>
	 <20080329031146.6FF7126FA1D@magilla.localdomain>
Content-Type: text/plain
Date: Wed, 09 Apr 2008 12:45:32 +0100
Message-Id: <1207741532.27048.64.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-4.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-28 at 20:11 -0700, Roland McGrath wrote:
> Change all the #ifdef TIF_RESTORE_SIGMASK conditionals in non-arch
> code to #ifdef HAVE_SET_RESTORE_SIGMASK.

That ifdef was only supposed to be a temporary thing until all
architectures had implemented TIF_RESTORE_SIGMASK anyway.

It looks like only ARM, v850 and m68k which are still missing it; if
those three architectures can catch up, then hopefully it can die off
completely quite soon.

-- 
dwmw2

