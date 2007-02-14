Return-Path: <linux-kernel-owner+w=401wt.eu-S1750857AbXBNBQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750857AbXBNBQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 20:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbXBNBQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 20:16:17 -0500
Received: from gw.goop.org ([64.81.55.164]:41593 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbXBNBQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 20:16:17 -0500
Message-ID: <45D262DC.2020008@goop.org>
Date: Tue, 13 Feb 2007 17:16:12 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 10/21] Xen-paravirt: Name: dont export paravirt_ops structure,
 do individual functions
References: <20070213221729.772002682@goop.org> <20070213221830.238235953@goop.org> <45D260A2.4010200@vmware.com>
In-Reply-To: <45D260A2.4010200@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> This turned out really hideous looking to me.  Can't we split the
> struct into GPL'd and non-GPL'd functions instead?  We still have the
> same granularity, and none of this function call to an indirect
> function call nonsense. 

It's not pretty, but I think having paravirt_ops and paravirt_ops_gpl
would be worse.  I'd be sympathetic to the idea of splitting
paravirt_ops up by function groupings, but splitting it by license seems
like a maintenance headache with no real upside.  Besides, patching will
solve everything (tm).

    J
