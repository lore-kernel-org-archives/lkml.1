Return-Path: <linux-kernel-owner+w=401wt.eu-S1751036AbXCSSNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751036AbXCSSNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 14:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbXCSSNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 14:13:18 -0400
Received: from gw.goop.org ([64.81.55.164]:57257 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbXCSSNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 14:13:17 -0400
Message-ID: <45FED2BA.5050207@goop.org>
Date: Mon, 19 Mar 2007 11:13:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Chris Wright <chrisw@sous-sol.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Adrian Bunk <bunk@stusta.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 20/26] Xen-paravirt_ops: Core Xen implementation
References: <20070301232443.195603797@goop.org>	<20070301232528.812011702@goop.org> <20070316091411.GF23174@elte.hu>	<20070316171250.GM10574@sequoia.sous-sol.org> <m1aby9xg5s.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1aby9xg5s.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>>>>  ENTRY(swapper_pg_dir)
>>>> +	.align PAGE_SIZE_asm
>>>>  	.fill 1024,4,0
>>>>         
>>>
> Shouldn't the align be before the label.  Otherwise padding
> would be inserted between the label and the data.


Good point.

Thanks,
    J
