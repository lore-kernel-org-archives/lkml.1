Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbYIIQGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbYIIQGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYIIQGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:06:37 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:42126 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbYIIQGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:06:36 -0400
Date: Tue, 9 Sep 2008 19:04:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Keith A. Prickett" <keithp@marvell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Building Kernel with -O0
Message-ID: <20080909160452.GB30160@cs181140183.pp.htv.fi>
References: <1220550653.15123.6.camel@CV-LAB2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1220550653.15123.6.camel@CV-LAB2>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 10:50:53AM -0700, Keith A. Prickett wrote:
>...
> It seems building with optimization
> level 0 should be a natural thing for kernel driver developers to do for
> debugging purposes.
> 
> In summary: I want to compile with optimizations off and the compile is
> failing now when I try this.  How can this be resolved?
>...

There are several places in the kernel where we e.g. rely on gcc 
removing dead code, and otherwise the linking of the kernel fails.

Compiling with -O0 never worked, and is not likely to ever work.

> Thanks in advance,
> Keith Prickett

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

