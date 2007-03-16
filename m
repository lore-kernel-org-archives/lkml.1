Return-Path: <linux-kernel-owner+w=401wt.eu-S965837AbXCPSnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965837AbXCPSnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 14:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965831AbXCPSnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 14:43:49 -0400
Received: from gw.goop.org ([64.81.55.164]:50477 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965837AbXCPSns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 14:43:48 -0400
Message-ID: <45FAE560.10401@goop.org>
Date: Fri, 16 Mar 2007 11:43:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 03/26] Xen-paravirt_ops: use paravirt_nop to consistently
 mark no-op operations
References: <20070301232443.195603797@goop.org> <20070301232526.261284776@goop.org> <20070316094432.GU23174@elte.hu>
In-Reply-To: <20070316094432.GU23174@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> but only as a cleanup of the current open-coded (void *) casts. My 
> problem with this is that it loses the types. Not that there is much to 
> check for, but still, this adds some assumptions about how function 
> calls look like.

I agree.  I don't generally like this kind of hack, but having a single
test for "func == paravirt_nop" to look for nop pv_ops in the patcher is
what tipped the balance.

    J
