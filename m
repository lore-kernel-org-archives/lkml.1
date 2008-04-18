Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbYDRFte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbYDRFte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 01:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbYDRFtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 01:49:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48963 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbYDRFtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 01:49:22 -0400
Date: Thu, 17 Apr 2008 22:49:08 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: 2.6.25-mm1: not looking good
Message-ID: <20080417224908.67cec814@laptopd505.fenrus.org>
In-Reply-To: <20080417160331.b4729f0c.akpm@linux-foundation.org>
References: <20080417160331.b4729f0c.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 16:03:31 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> I repulled all the trees an hour or two ago, installed everything on
> an 8-way x86_64 box and:
> 
> 
> stack-protector:
> 
> Testing -fstack-protector-all feature
> No -fstack-protector-stack-frame!
> -fstack-protector-all test failed

do you have a stack-protector capable GCC? I guess not.

This is a catch-22. You do not have stack-protector. Should we make that 
a silent failure? or do you want to know that you don't have a security
feature you thought you had.... complaining seems to be the right thing to do imo.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
