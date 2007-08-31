Return-Path: <linux-kernel-owner+w=401wt.eu-S1763334AbXHaBFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763334AbXHaBFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 21:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbXHaBFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 21:05:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56121 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057AbXHaBFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 21:05:45 -0400
Date: Thu, 30 Aug 2007 18:05:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 and x86_64: randomize brk()
Message-Id: <20070830180538.b52b802d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0708301708590.4135@jikos.suse.cz>
References: <Pine.LNX.4.64.0708301545100.4135@jikos.suse.cz>
	<8bd0f97a0708300701r1f36bc0anc45b9cad4a11f2ef@mail.gmail.com>
	<Pine.LNX.4.64.0708301620010.4135@jikos.suse.cz>
	<8bd0f97a0708300726h563808a6j2b2ef9adf805c109@mail.gmail.com>
	<Pine.LNX.4.64.0708301708590.4135@jikos.suse.cz>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007 17:10:03 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:

> On Thu, 30 Aug 2007, Mike Frysinger wrote:
> 
> > Blackfin too please :) i think v850 also falls into this category, but 
> > i'm not terribly familiar with it ...
> 
> Andrew, do you still strongly oppose to having ARCH_HAS_RANDOMIZE_BRK 
> macro instead please?
> 

Not strongly, but the general opinion seems to be that ARCH_HAS_FOO is
sucky.  It should at least be done in Kconfig rather than in .h, but even
better is just to implement the thing for all architectures.

Please ask checkpatch.pl about you patch, too.  It has commonly-occurring
coding mishaps.

