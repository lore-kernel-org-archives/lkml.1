Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbYH2IMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbYH2IMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYH2IM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:12:28 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:49964 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbYH2IM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:12:27 -0400
Date: Fri, 29 Aug 2008 09:12:08 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: Re: linux-next: Tree for August 28
Message-ID: <20080829081154.GB3387@brain>
References: <20080828183307.23c6be82.sfr@canb.auug.org.au> <20080828143934.a5034a01.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828143934.a5034a01.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 02:39:34PM -0700, Andrew Morton wrote:
> On Thu, 28 Aug 2008 18:33:07 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> 
> firmware/yamaha/yss225_registers.bin.ihex uses \r\n line termination.
> Is that actually required, or can we use plain old \n?
> 
> Andy, a checkpatch rule for this would be nice.

Ahhh, well we do have a check for DOS line endings, but it only applies
to 'source' files.  I guess what we should do is bring ihex in as a
'text' file format and apply limited checks to that.

-apw
