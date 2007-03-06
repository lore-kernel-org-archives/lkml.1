Return-Path: <linux-kernel-owner+w=401wt.eu-S933089AbXCFJOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089AbXCFJOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933159AbXCFJOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:14:55 -0500
Received: from gw.goop.org ([64.81.55.164]:45635 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933089AbXCFJOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:14:53 -0500
Message-ID: <45ED310D.1000407@goop.org>
Date: Tue, 06 Mar 2007 01:14:53 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [patch] paravirt: VDSO page is essential
References: <20070306091307.259DC1801C4@magilla.sf.frob.com>
In-Reply-To: <20070306091307.259DC1801C4@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> For everything else to work, it needs to be set by changing __FIXADDR_TOP,
> which seems to be done by calling reserve_top_address early enough.
> It looks like that needs to be properly tied into paravirt_ops somehow.
>   

The startup code for whatever hypervisor you're running makes a call to
reserve_top to reserve the appropriate amount of address space.  This
happens very early.

    J
