Return-Path: <linux-kernel-owner+w=401wt.eu-S965703AbXCPREO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965703AbXCPREO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965693AbXCPREO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:04:14 -0400
Received: from gw.goop.org ([64.81.55.164]:55996 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965680AbXCPREN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:04:13 -0400
Message-ID: <45FACE0D.4010108@goop.org>
Date: Fri, 16 Mar 2007 10:04:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 18/26] Xen-paravirt_ops: Add XEN config options
References: <20070301232443.195603797@goop.org> <20070301232528.462923016@goop.org> <20070316091454.GG23174@elte.hu>
In-Reply-To: <20070316091454.GG23174@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Xen is currently incompatible with:
>> - PREEMPT
>>     
>
> why? That should be fixed.

Actually I don't think that's true any more.  We'll need to work out how
to deal with preempt and suspend/resume, but the process freezer seems
like the way to do that.

    J
