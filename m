Return-Path: <linux-kernel-owner+w=401wt.eu-S933094AbXCHTTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094AbXCHTTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933099AbXCHTTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:19:43 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:40710 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933094AbXCHTTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:19:42 -0500
Date: Thu, 8 Mar 2007 11:14:09 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Daniel Arai <arai@vmware.com>
Cc: Chris Wright <chrisw@sous-sol.org>, tglx@linutronix.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
Message-ID: <20070308191409.GI10574@sequoia.sous-sol.org>
References: <45EF0CF5.5090305@goop.org> <45EF175D.6030609@vmware.com> <1173302503.24738.795.camel@localhost.localdomain> <45EF372E.7030600@goop.org> <1173308717.24738.898.camel@localhost.localdomain> <45EF49E9.7040509@vmware.com> <1173313373.24738.937.camel@localhost.localdomain> <45EF6077.9090302@vmware.com> <20070308182456.GH19575@sequoia.sous-sol.org> <45F05999.20803@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F05999.20803@vmware.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Arai (arai@vmware.com) wrote:
> Chris, would you like to work together on this?  I don't know what Xen's 
> requirements are for the APIC interface.  Do you think we could come up 
> with something that would fit both of our needs, and maybe also be usable 
> for some of the subarch-specific code?

Sure, we just have a pretty small genapic_xen, and then enough (hackery,
this should be sorted out) to use that genapic and have an effective
override for __send_IPI_shortcut.

thanks,
-chris
