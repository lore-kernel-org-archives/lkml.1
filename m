Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934456Ab0CLTFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 14:05:42 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:17143 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131Ab0CLTFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 14:05:41 -0500
X-IronPort-AV: E=Sophos;i="4.49,627,1262563200"; 
   d="scan'208";a="9922725"
Date: Fri, 12 Mar 2010 19:09:54 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2 of 5] early PV on HVM
In-Reply-To: <4B995EA6.8080105@goop.org>
Message-ID: <alpine.DEB.2.00.1003121819500.27222@kaball-desktop>
References: <alpine.DEB.2.00.1003101501320.28412@kaball-desktop> <4B995EA6.8080105@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010, Jeremy Fitzhardinge wrote:
> On 03/10/2010 07:47 AM, Stefano Stabellini wrote:
> > Hi all,
> > this patch:
> >
> > - adds a xen_guest_init hook in setup.c right after kvm_guest_init;
> >
> > - initializes basic pv on hvm features in xen_guest_init;
> >    
> 
> Is this 64-bit specific like Sheng's version?
> 
> I also asked him to move the setup code out of enlighten.c into a new 
> file, though your version is a fair bit smaller.
> 

My version is not 64-bit specific, should I move it to a new file
anyway?

I was trying to keep the differences with Sheng's version low, but in
this case I am not quite sure how to manage it.
Suggestions are welcome.

