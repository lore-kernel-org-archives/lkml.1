Return-Path: <linux-kernel-owner+w=401wt.eu-S1760621AbYF3Qnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621AbYF3Qnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 12:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbYF3Qnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 12:43:39 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42563 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbYF3Qni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 12:43:38 -0400
Date: Mon, 30 Jun 2008 19:43:24 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: Benny Halevy <bhalevy@panasas.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix extern inline errors with gcc 4.3.0
Message-ID: <20080630164324.GA1536@cs181140183.pp.htv.fi>
References: <1214488251-20927-1-git-send-email-bhalevy@panasas.com> <20080627162645.GC8381@c2.user-mode-linux.org> <7225594ED4A1304C9E43D030A886D221050BE1@daytona.int.panasas.com> <48673A9B.8050907@panasas.com> <20080630162201.GC6643@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080630162201.GC6643@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 12:22:01PM -0400, Jeff Dike wrote:
> On Sun, Jun 29, 2008 at 10:32:43AM +0300, Benny Halevy wrote:
> > Note that the crash happened with gcc 4.1.2 and it will get the
> > -fno-unit-at-a-time flag with the proposed patch.
> > 
> > That said, this option or the lack of it ought not to cause any
> > runtime crashes.  If it does, I'd feel much more comfortable to know
> > exactly what the root cause is before deciding to use the flag to
> > workaround^hide it.
> 
> I agree.
> 
> The constraints on [no-]unit-at-a-time that I see are:
>...
> 	x86_64 uses unit-at-a-time always
>...

The only gcc versions that ever supported unit-at-a-time without 
enabling it by default was some patched gcc 3.3 that included a
backport of unit-at-a-time to gcc 3.3.

Just as a note that I doubt this matters in practice today.

> 				Jeff

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

