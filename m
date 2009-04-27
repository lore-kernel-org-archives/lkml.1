Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbZD0Mqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbZD0Mqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 08:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbZD0Mqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 08:46:33 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:47094 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090AbZD0Mqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 08:46:32 -0400
Date: Mon, 27 Apr 2009 14:48:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: monstr@monstr.eu, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, john.williams@petalogix.com
Subject: Re: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
Message-ID: <20090427124839.GA9668@uranus.ravnborg.org>
References: <1240821139-7247-23-git-send-email-monstr@monstr.eu> <200904271357.01681.arnd@arndb.de> <20090427121556.GA9469@uranus.ravnborg.org> <200904271437.09273.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904271437.09273.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 02:37:08PM +0200, Arnd Bergmann wrote:
> On Monday 27 April 2009, Sam Ravnborg wrote:
> > Why not use __u64/__u32 (and s32/s64 where appropriate)?
> > Historical baggage or a techncal reason?
> 
> Yes, purely historical reasons: all architectures currently
> use the simple C types rather than __u32 in stat.h.
> 
> I don't think it makes a difference either way, so I'd
> leave it like this unless you find a good reason for
> changing.

The reason I had was:
1) consistency. We say that we should use the width specific types in our interfaces
2) readability. We expect to see the kernel types used - so we know then and does not
                start to wonder why we did not use them here.
3) documentation. The __{u,s}{32,64} documents the size better than "unsigned int" / long long" etc.

But no technical atrong arguments.

	Sam
