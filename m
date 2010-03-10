Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab0CJPZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:25:29 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:25002 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab0CJPZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:25:26 -0500
X-IronPort-AV: E=Sophos;i="4.49,614,1262563200"; 
   d="scan'208";a="9879709"
Date: Wed, 10 Mar 2010 15:29:30 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Sheng Yang <sheng@linux.intel.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Konrad Rzeszutek Wilk <kliw@darnok.org>
Subject: Re: [Xen-devel] [PATCH 7/7] xen: Enable event channel of PV extension
 of HVM
In-Reply-To: <201003101056.42511.sheng@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1003101452540.28412@kaball-desktop>
References: <1268032732-8025-1-git-send-email-sheng@linux.intel.com> <1268128085.11737.59761.camel@zakaz.uk.xensource.com> <alpine.DEB.2.00.1003090954010.4869@kaball-desktop> <201003101056.42511.sheng@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010, Sheng Yang wrote:
> I think we can leave the controversial thing later. At least, we want a 
> framework for PV extension of HVM. We can work together to determine what is 
> the better way for evtchn, as well as porting pirqs. (And the later MSI work 
> may also depends on it)
> 

Most of my patch series can be upstreamed right now, the only thing that
needs some extra work is the pirq remapping.
So yes, we can upstream the rest and that would also make PV on HVM work
on linux upstream ASAP.
I think that is a worthy goal by itself, therefore I am going to send
another reduced patch series, ready to be upstreamed, without pirq
remappings, with support for PV on HVM.

