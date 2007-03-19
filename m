Return-Path: <linux-kernel-owner+w=401wt.eu-S1030449AbXCSSIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030449AbXCSSIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 14:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030463AbXCSSIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 14:08:24 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43910 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030449AbXCSSIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 14:08:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chris Wright <chrisw@sous-sol.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Adrian Bunk <bunk@stusta.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 20/26] Xen-paravirt_ops: Core Xen implementation
References: <20070301232443.195603797@goop.org>
	<20070301232528.812011702@goop.org> <20070316091411.GF23174@elte.hu>
	<20070316171250.GM10574@sequoia.sous-sol.org>
Date: Mon, 19 Mar 2007 12:05:35 -0600
In-Reply-To: <20070316171250.GM10574@sequoia.sous-sol.org> (Chris Wright's
	message of "Fri, 16 Mar 2007 10:12:50 -0700")
Message-ID: <m1aby9xg5s.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright <chrisw@sous-sol.org> writes:

> * Ingo Molnar (mingo@elte.hu) wrote:
>> >  ENTRY(swapper_pg_dir)
>> > +	.align PAGE_SIZE_asm
>> >  	.fill 1024,4,0
>> 
>> does the native kernel lose memory here?
>
> Not in my builds.

Shouldn't the align be before the label.  Otherwise padding
would be inserted between the label and the data.

Eric
