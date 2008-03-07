Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbYCGXof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbYCGXof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 18:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbYCGXoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 18:44:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40417 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759611AbYCGXoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 18:44:11 -0500
Subject: Re: headersinstall of kvm.h does not work
From: David Woodhouse <dwmw2@infradead.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Avi Kivity <avi@qumranet.com>, Sam Ravnborg <sam@ravnborg.org>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <200803071326.06682.borntraeger@de.ibm.com>
References: <200803071326.06682.borntraeger@de.ibm.com>
Content-Type: text/plain
Date: Sat, 08 Mar 2008 00:43:38 +0100
Message-Id: <1204933418.2495.14.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-03-07 at 13:26 +0100, Christian Borntraeger wrote:
> +unifdef-$(CONFIG_HAVE_KVM) += kvm.h
>  unifdef-y += llc.h
>  unifdef-y += loop.h
> ----snip------
> 
> This patch does not work. Kbuild (scripts/Makefile.headersinst) does
> not check the config file, so kvm.h is never installed.
> 
> Sam is there an easy way to allow constructs like
> "unifdef-$(CONFIG_FOO)"?

That might be justifiable for HAVE_xxx which is a constant for any given
architecture -- but I predict that soon as we add such a facility, it
would get abused for stuff which really _is_ configurable. And that
would make me sad.

-- 
dwmw2

