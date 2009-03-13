Return-Path: <linux-kernel-owner+w=401wt.eu-S1757804AbZCMGoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804AbZCMGoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 02:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbZCMGoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 02:44:18 -0400
Received: from ozlabs.org ([203.10.76.45]:40468 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084AbZCMGoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 02:44:14 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PULL] x86 cpumask work
Date: Fri, 13 Mar 2009 17:14:07 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Mike Travis <travis@sgi.com>
References: <200903121453.45163.rusty@rustcorp.com.au> <20090313052754.GA20389@elte.hu> <20090313053214.GA21183@elte.hu>
In-Reply-To: <20090313053214.GA21183@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903131714.07568.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 March 2009 16:02:14 Ingo Molnar wrote:
> 
> another box crashed too, with:
> 
> Total of 1 processors activated (1994.75 BogoMIPS).                                 
> BUG: unable to handle kernel NULL pointer dereference at (null)                     
> IP: [<ffffffff8025931c>] cpu_attach_domain+0x77/0x1f9         

Same as first, which I've reproduced.  A bit confused how I broke
this code, but I'll track it down...

Thanks!
Rusty.


