Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab0CETpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:45:47 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:63181 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab0CETpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:45:46 -0500
X-IronPort-AV: E=Sophos;i="4.49,588,1262581200"; 
   d="scan'208";a="86887512"
Subject: Re: Infinite loop on boot in free_early_partial due to start==end
 on tip/master
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4B914A61.20409@kernel.org>
References: <1267801390.11737.38014.camel@zakaz.uk.xensource.com>
	 <4B914A61.20409@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Fri, 5 Mar 2010 19:45:42 +0000
Message-ID: <1267818342.20243.35.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 18:16 +0000, Yinghai Lu wrote:
> 
> > +     if (unlikely(start>=end)) {
> > +             WARN_ONCE(1, "free_early_partial get wrong start/end
> \n:);
> > +             return;
> > +     }
> > + 

Sure, although this can be written:

if (WARN_ONCE(start >= end, "free_early_partial.....\n"))
return;

Updated patch to follow.

Ian.



