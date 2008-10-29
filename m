Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758AbYJ2G4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbYJ2G4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 02:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbYJ2G4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 02:56:05 -0400
Received: from smtp6-g19.free.fr ([212.27.42.36]:46614 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbYJ2G4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 02:56:04 -0400
Date: Wed, 29 Oct 2008 07:54:28 +0100
From: Yves-Alexis Perez <corsac@debian.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       "Carlos R. Mafra" <crmafra2@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Long delays and keystrokes required - related to disk
	encryption?
Message-ID: <20081029065428.GA15581@corsac.net>
References: <200810281744.52587.elendil@planet.nl> <200810290153.23514.elendil@planet.nl> <4907D957.6040206@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4907D957.6040206@linux.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 08:32:39PM -0700, Arjan van de Ven wrote:
> ok one easy thing to try, in the peek function (that this patch touches),
> just stick a "return" as first statement in.
> If that "fixes" it, we have a real issue with hrtimers, if not then something else is going on..

At first sight, it fixes it, yes. Tried on a recent git pull. I'll try
to rebuild it without the fix to see if the problem reappears or if it
was a side-effect from other change.

Cheers,
-- 
Yves-Alexis
