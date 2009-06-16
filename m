Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbZFPUat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbZFPUat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbZFPUal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:30:41 -0400
Received: from thunk.org ([69.25.196.29]:49523 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbZFPUak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:30:40 -0400
Date: Tue, 16 Jun 2009 16:30:34 -0400
From: Theodore Tso <tytso@mit.edu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: linux-next: ext4 tree build failure
Message-ID: <20090616203034.GB14788@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
	Christoph Lameter <cl@linux-foundation.org>
References: <20090616144413.50e975f9.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616144413.50e975f9.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 02:44:13PM +1000, Stephen Rothwell wrote:
> Hi Ted,
> 
> Today's linux-next build (powerpc ppc64_defconfig) failed like this after
> the slab tree was merged:
> 
> In file included from fs/jbd2/checkpoint.c:26:
> include/trace/events/jbd2.h:11: error: expected ')' before '(' token
> include/trace/events/jbd2.h:31: error: expected ')' before '(' token

Hmm... I wonder why the slab tree would be messing with tracing
include files.

Which slab tree is it?  Is it Pekka's?

      git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git

					- Ted
