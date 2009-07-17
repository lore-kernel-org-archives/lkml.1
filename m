Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbZGQWzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbZGQWzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 18:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757972AbZGQWzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 18:55:32 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57064 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757945AbZGQWzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 18:55:32 -0400
Subject: Re: Duplicate vsyscall/vdso gettimeofday implementations on x86_64
From: john stultz <johnstul@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@tglx.de>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <87eisfvtzv.fsf@basil.nowhere.org>
References: <1247868130.8334.40.camel@localhost.localdomain>
	 <87eisfvtzv.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 15:54:44 -0700
Message-Id: <1247871284.8334.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-18 at 00:12 +0200, Andi Kleen wrote:
> john stultz <johnstul@us.ibm.com> writes:
> 
> > I think the implementation in vclock_gettime.c is nice, as it mostly
> > reuses the clock_gettime() code, but I don't think it actually gets
> > called.
> 
> It depends on what glibc uses.

Hrmm. Can we deprecate the old method and push glibc to use the new one?
If we remove it the vsyscall interface will old glibc's fall-back
gracefully? 

thanks
-john


