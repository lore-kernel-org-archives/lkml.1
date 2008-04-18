Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbYDRNwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbYDRNwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 09:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYDRNvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 09:51:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50887 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYDRNvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 09:51:53 -0400
Date: Fri, 18 Apr 2008 06:51:27 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Reuben Farrelly <reuben-linuxkernel@reub.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: StackProtector Oopses - Re: 2.6.25-mm1
Message-ID: <20080418065127.3005c671@laptopd505.fenrus.org>
In-Reply-To: <20080418133645.GF31797@elte.hu>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	<48089BDE.6040100@reub.net>
	<20080418133645.GF31797@elte.hu>
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

On Fri, 18 Apr 2008 15:36:45 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Reuben Farrelly <reuben-linuxkernel@reub.net> wrote:
> 
> > is enough to prevent my system booting, viz:
> 
> hm, does it boot up fine with the attached patch and stackprotector 
> enabled? It appears that your system got to the self-test so 
> stackprotector is working mostly - it's just that the self-test went 
> wrong.
> 

yes it'll be interesting to see if this is due to the test triggering or due to
something else.

Reuben:
I assume your gcc is pretty vanilla and doesn't have weird patches in this area?

Can you do a (with the test enabled in the config/code) do a
make kernel/panic.s
and send me that file? (this allows me to see what code your gcc generated for the test)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
