Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbYJ2HLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbYJ2HLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 03:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYJ2HLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 03:11:46 -0400
Received: from molly.corsac.net ([81.57.48.219]:37050 "EHLO molly.corsac.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbYJ2HLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 03:11:46 -0400
X-Greylist: delayed 1034 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Oct 2008 03:11:45 EDT
Date: Wed, 29 Oct 2008 08:11:43 +0100
From: Yves-Alexis Perez <corsac@debian.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       "Carlos R. Mafra" <crmafra2@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Long delays and keystrokes required - related to disk
	encryption?
Message-ID: <20081029071143.GA15736@corsac.net>
References: <200810281744.52587.elendil@planet.nl> <200810290153.23514.elendil@planet.nl> <4907D957.6040206@linux.intel.com> <20081029065428.GA15581@corsac.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081029065428.GA15581@corsac.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 07:54:28AM +0100, Yves-Alexis Perez wrote:
> On Tue, Oct 28, 2008 at 08:32:39PM -0700, Arjan van de Ven wrote:
> > ok one easy thing to try, in the peek function (that this patch touches),
> > just stick a "return" as first statement in.
> > If that "fixes" it, we have a real issue with hrtimers, if not then something else is going on..
> 
> At first sight, it fixes it, yes. Tried on a recent git pull. I'll try
> to rebuild it without the fix to see if the problem reappears or if it
> was a side-effect from other change.

Confirmed, removing the “return;” shows the problem back. So I guess we
have a real issue with hrtimers :/

Cheers,
-- 
Yves-Alexis
