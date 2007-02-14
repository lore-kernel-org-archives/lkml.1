Return-Path: <linux-kernel-owner+w=401wt.eu-S1751022AbXBNIoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751022AbXBNIoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 03:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbXBNIoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 03:44:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbXBNIoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 03:44:12 -0500
Message-ID: <45D2CBC5.90809@suse.de>
Date: Wed, 14 Feb 2007 09:43:49 +0100
From: Gerd Hoffmann <kraxel@suse.de>
Organization: =?ISO-8859-1?Q?SUSE_LINUX_Products_GmbH=2C_GF=3A_?=
 =?ISO-8859-1?Q?Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Dan Hecht <dhecht@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@muc.de>, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 05/21] Xen-paravirt: paravirt_ops: allocate a fixmap slot
References: <20070213221729.772002682@goop.org>	<20070213221829.845132535@goop.org>	<45D2649D.4080508@vmware.com> <45D26797.5090600@goop.org> <45D27534.1070608@vmware.com>
In-Reply-To: <45D27534.1070608@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Hecht wrote:
> Right.  But that is only because Xen decides to allocate the page from 
> the (machine) physical space, rather than from the pseudo-physical 
> space.  My question is: why doesn't Xen allocate shared_info from the 
> pseudo-physical space?

Historical reasons ...

> If it had, then this page wouldn't need to be 
> treated specially.  I'm not sure, but I seem to remember on 64-bit 
> Xen/XenLinux allocated shared_info from pseudo-physical space already...

Yep, the ia64 port which came later handles some things differently,
specifically some "magic" pages are allocated more clever ;)

Changing that for x86 would break existing guests though.

cheers,
  Gerd

-- 
Gerd Hoffmann <kraxel@suse.de>
