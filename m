Return-Path: <linux-kernel-owner+w=401wt.eu-S965578AbXCSXXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965578AbXCSXXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 19:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965573AbXCSXXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 19:23:30 -0400
Received: from ozlabs.org ([203.10.76.45]:46464 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965584AbXCSXX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 19:23:29 -0400
Subject: Re: [PATCH RESEND 2/2] Fix some kallsyms_lookup() vs rmmod races
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@osdl.org, linux-kernel@vger.kernel.org,
       devel@openvz.org, tglx@linutronix.de, viro@zeniv.linux.org.uk,
       pmarques@grupopie.com
In-Reply-To: <20070319102107.GA6811@localhost.sw.ru>
References: <20070316114458.GB6817@localhost.sw.ru>
	 <20070316115154.GC30195@elte.hu>
	 <1174124239.8897.41.camel@localhost.localdomain>
	 <20070319102107.GA6811@localhost.sw.ru>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 10:23:07 +1100
Message-Id: <1174346587.11680.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 13:21 +0300, Alexey Dobriyan wrote:
> I very much agree with proto-patch which _copies_ all relevant
> information into caller-supplied structure, keeping module_mutex private.
> Time to split it sanely.

Indeed.  The current interface needs to be ripped apart and put together
sanely.

Thanks!
Rusty.

