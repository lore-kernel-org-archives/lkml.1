Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbZEYLMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbZEYLMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbZEYLMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:12:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbZEYLMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:12:46 -0400
Date: Mon, 25 May 2009 13:12:44 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, matthew.r.wilcox@intel.com
Subject: Re: kernel BUG at mm/slqb.c:1411!
Message-ID: <20090525111244.GA24071@wotan.suse.de>
References: <1242289830.21646.5.camel@penberg-laptop> <20090514175332.9B7B.A69D9226@jp.fujitsu.com> <20090515083726.F5BF.A69D9226@jp.fujitsu.com> <1242374931.21646.30.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242374931.21646.30.camel@penberg-laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 11:08:51AM +0300, Pekka Enberg wrote:
> Hi Motohiro-san,
> 
> On Wed, 2009-05-13 at 17:37 +0900, Minchan Kim wrote:
> On Fri, 2009-05-15 at 08:38 +0900, KOSAKI Motohiro wrote:
> > -ENOTREPRODUCED
> > 
> > I guess your patch is right fix. thanks!
> 
> Thank you so much for testing!
> 
> Nick seems to have gone silent for the past few days so I went ahead and
> merged the patch.

Sorry Pekka... I do think the patch looks OK, thanks for that.

 
> Did you have CONFIG_PROVE_LOCKING enabled, btw? I think I got the lock
> order correct but I don't have a NUMA machine to test it with here.
