Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab0CIJsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 04:48:11 -0500
Received: from smtp.citrix.com ([66.165.176.89]:60560 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853Ab0CIJsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 04:48:08 -0500
X-IronPort-AV: E=Sophos;i="4.49,607,1262581200"; 
   d="scan'208";a="7490399"
Subject: Re: [Xen-devel] [PATCH 7/7] xen: Enable event channel of PV
 extension of HVM
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Sheng Yang <sheng@linux.intel.com>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Konrad Rzeszutek Wilk <kliw@darnok.org>
In-Reply-To: <4B95F224.3060205@goop.org>
References: <1268032732-8025-1-git-send-email-sheng@linux.intel.com>
	 <1268032732-8025-8-git-send-email-sheng@linux.intel.com>
	 <alpine.DEB.2.00.1003081701160.16237@kaball-desktop>
	 <201003090953.16985.sheng@linux.intel.com>  <4B95F224.3060205@goop.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 9 Mar 2010 09:48:05 +0000
Message-ID: <1268128085.11737.59761.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 07:00 +0000, Jeremy Fitzhardinge wrote:
> On 03/08/2010 05:53 PM, Sheng Yang wrote:
> > On Tuesday 09 March 2010 01:10:56 Stefano Stabellini wrote:
> >    
> >> I think that mapping interrupts into VIRQs is a bad idea: you should map
> >> interrupts into pirqs instead, the code exists already on the kernel
> >> side so we don't need to do any (ugly) change ther.
> >>      
> > The code existed in the pv_ops dom0 side, but not in the upstream Linux. The
> > latter is our target. We want this work to be accepted by upstream Linux soon.

>    2. It has significant overlaps with the current xen.git development
>       which is also targeted for upstream.  There's no point in creating
>       an unnecessary duplicate mechanism when the infrastructure will be
>       in place anyway.

There's also nothing stopping us from upstreaming portions of the "dom0"
patchset ahead of full dom0 support if it is useful for some domU
feature.

Ian.


