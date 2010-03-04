Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab0CDUZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 15:25:13 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:2074 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410Ab0CDUZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 15:25:11 -0500
X-IronPort-AV: E=Sophos;i="4.49,582,1262581200"; 
   d="scan'208";a="86726712"
Subject: Re: [PATCH 6/7] xen: Enable PV clocksource for HVM
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Sheng Yang <sheng@linux.intel.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>
In-Reply-To: <4B8FF0A3.9060305@goop.org>
References: <1267695416-14988-1-git-send-email-sheng@linux.intel.com>
	 <1267695416-14988-7-git-send-email-sheng@linux.intel.com>
	 <4B8FF0A3.9060305@goop.org>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Thu, 4 Mar 2010 20:25:03 +0000
Message-ID: <1267734303.20243.5.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 09:40 -0800, Jeremy Fitzhardinge wrote:
> 
> > +
> > +static void __init init_pv_clocksource(void)
> > +{
> > +     if (enable_hvm_pv(HVM_PV_CLOCK))
> > +             BUG();
> >    
> 
> BUG is a bit severe.  Will it really never, ever fail?  

When running on a hypervisor without these extension, for example.

Ian.
-- 
Ian Campbell

My polyvinyl cowboy wallet was made in Hong Kong by Montgomery Clift!

