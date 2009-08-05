Return-Path: <linux-kernel-owner+w=401wt.eu-S1751961AbZHESkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbZHESkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 14:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbZHESkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 14:40:32 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:52130 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZHESkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 14:40:31 -0400
Date: Wed, 5 Aug 2009 20:40:28 +0200
From: Daniel Mack <daniel@caiaq.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Woodhouse <dwmw2@infradead.org>, Eric Miao <eric.y.miao@gmail.com>,
       - Cortez - <omegamoon@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel@jasper.es
Subject: Re: 2.6.31-rc1: zaurus suspend regressing
Message-ID: <20090805184028.GN13236@buzzloop.caiaq.de>
References: <20090704024416.GA1345@ucw.cz> <1249492113.9324.369.camel@macbook.infradead.org> <20090805172238.GM13236@buzzloop.caiaq.de> <200908052037.15066.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908052037.15066.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 08:37:13PM +0200, Rafael J. Wysocki wrote:
> On Wednesday 05 August 2009, Daniel Mack wrote:
> > On Wed, Aug 05, 2009 at 06:08:33PM +0100, David Woodhouse wrote:
> > > On Wed, 2009-08-05 at 18:30 +0200, Daniel Mack wrote:
> > > > 
> > > > That bug hit me as well, and as in Cortez' case, reverting 15bce40
> > > > fixed
> > > > it for me on a PXA3xx platform.
> > > 
> > > Can you confirm that the fix in the mtd-2.6.git tree is sufficient?
> > 
> > Yep, thanks!
> 
> Any pointer to the fix patch, please?

I merged the whole tree from
http://git.infradead.org/?p=mtd-2.6.git;a=summary

Haven't exactly bisected which specific fix was necessary, but (6afc4f:
mtd: fix the conversion from dev to mtd_info) looks like it fixes a
serious bug.

Maybe David can elaborate some more?

Daniel
