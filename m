Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbYHMFvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbYHMFvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 01:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYHMFvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 01:51:25 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:53968 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYHMFvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 01:51:25 -0400
Date: Wed, 13 Aug 2008 15:51:24 +1000
From: Simon Horman <horms@verge.net.au>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kexec jump: fix code size checking
Message-ID: <20080813055122.GB30294@verge.net.au>
References: <1218589475.24951.59.camel@caritas-dev.intel.com> <20080813024701.GA19201@verge.net.au> <1218596715.24951.69.camel@caritas-dev.intel.com> <m1d4kdk2fw.fsf@frodo.ebiederm.org> <1218604692.24951.92.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218604692.24951.92.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 01:18:12PM +0800, Huang Ying wrote:
> On Tue, 2008-08-12 at 20:40 -0700, Eric W. Biederman wrote:
> [...]
> > 4) Put the code is a special section .text.kexec? and have the linker
> >    always do the size comparison and the computation of the section size.
> > 
> > The fewer conditionals we have the less likely something is to break.
> 
> Yes. This one is good. But I think current one is acceptable too.

If you really think that 1) is the best way

Acked-by: Simon Horman <horms@verge.net.au>

