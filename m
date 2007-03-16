Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbXCPSjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbXCPSjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 14:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbXCPSjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 14:39:54 -0400
Received: from gw.goop.org ([64.81.55.164]:56937 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579AbXCPSjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 14:39:53 -0400
Message-ID: <45FAE46F.7080009@goop.org>
Date: Fri, 16 Mar 2007 11:39:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [patch 05/26] Xen-paravirt_ops: paravirt_ops: hooks to set up
 initial pagetable
References: <20070301232443.195603797@goop.org> <20070301232526.611972133@goop.org> <20070316093348.GS23174@elte.hu>
In-Reply-To: <20070316093348.GS23174@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> +	/* Make sure kernel address space is empty so that a pagetable
>> +	   will be allocated for it. */
>>     
>
> comment style.
>   

As you've noticed its a comment style I use quite often.  I use it for
what's essentially a little local comment, rather than a block comment
which really needs to draw attention to itself.  In this case, I think using

/*
 * Make sure kernel address space is empty so that a pagetable
 * will be allocated for it.
 */

is just too loud for what its trying to say.  If // comments were deemed
acceptable, I'd probably use them here instead.

    J
