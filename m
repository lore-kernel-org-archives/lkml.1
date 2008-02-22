Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbYBVPAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbYBVPAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 10:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbYBVO7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:59:55 -0500
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:33557 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868AbYBVO7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:59:54 -0500
Date: Fri, 22 Feb 2008 16:00:13 +0100
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Subject: Re: [PATCH] let XEN depend on PAE
In-reply-to: <1203687425.15721.45.camel@localhost.localdomain>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xen-devel@lists.xensource.com
Message-id: <47BEE37D.8040703@nets.rwth-aachen.de>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7BIT
X-IronPort-AV: E=Sophos;i="4.25,391,1199660400";   d="scan'208";a="32374213"
References: <47BEAB48.7050900@nets.rwth-aachen.de>
 <1203687425.15721.45.camel@localhost.localdomain>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell schrieb:
> On Fri, 2008-02-22 at 12:00 +0100, Arnd Hannemann wrote:
>> As paravirtualized xen guests won't work with !X86_PAE, change the Kconfig
>> accordingly.
> 
> Really? Xen guests should work on non-PAE if you have a non-PAE
> hypervisor (which most distros don't ship but which does exist).

Well if it should work, then something else is broken.
I have a non-PAE hypervisor, still xen guests compiled with !X86_PAE
from 2.6.24.2  and latest git won't work.
All the same with PAE enabled works.

http://lists.xensource.com/archives/html/xen-devel/2008-02/msg00716.html

> 
> Ian.
> 

Best regards,
Arnd
