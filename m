Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab0BCTnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:43:08 -0500
Received: from verein.lst.de ([213.95.11.210]:47874 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757620Ab0BCTnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:43:06 -0500
Date: Wed, 3 Feb 2010 20:42:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, roland@redhat.com, oleg@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 5/14] blackfin: use generic ptrace_resume code
Message-ID: <20100203194243.GA26014@lst.de>
References: <20100202185755.GA3630@lst.de> <20100202185907.GE3630@lst.de> <8bd0f97a1002021229x1c84d13flcc95102b7723468c@mail.gmail.com> <8bd0f97a1002031136h2573b05cr8dada3bd78ffaa38@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a1002031136h2573b05cr8dada3bd78ffaa38@mail.gmail.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 02:36:47PM -0500, Mike Frysinger wrote:
> i added tracehook support to Blackfin recently, so that covered all
> the new functions here.  i just had to drop the handling of the
> PTRACE_xxx things that common code already does.
> 
> when did you want to push through these updates ?  i was planning on
> sending these ptrace() updates through the Blackfin tree as part of my
> 2.6.34 queue.  i'm guessing you didnt want this stuff in 2.6.33 ...

No, it's all .34 material.  I'd say send your bits through the
microblaze tree.  The double prototype for the two functions won't
hurt during the merge window and we can fix it up later.  Just make
sure you really have user_{enable,disable}_single_step implement
as functions and not as a #define for ptrace_disable as in your
earlier version.

