Return-Path: <linux-kernel-owner+w=401wt.eu-S1763500AbXKNBOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763500AbXKNBOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761101AbXKNBOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:14:36 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59342 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759450AbXKNBOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:14:34 -0500
Date: Tue, 13 Nov 2007 17:11:36 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       Mark Lord <liml@rtr.ca>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071113171136.75ba098d@freepuppy.rosehill>
In-Reply-To: <473A46C1.3060000@redhat.com>
References: <20071113134029.GA30978@elte.hu>
	<4739AFE0.20705@rtr.ca>
	<20071113164650.GA28493@elte.hu>
	<4739E3D0.10201@rtr.ca>
	<20071113181228.GF4250@stusta.de>
	<4739EA83.5040006@rtr.ca>
	<20071113183605.GG4250@stusta.de>
	<4739F12E.5020807@rtr.ca>
	<20071113190428.GH4250@stusta.de>
	<4739FA4D.1050900@rtr.ca>
	<20071113200028.GJ4250@stusta.de>
	<20071113211256.1d18fe1a@the-village.bc.nu>
	<473A46C1.3060000@redhat.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 19:52:17 -0500
Chuck Ebbert <cebbert@redhat.com> wrote:

> On 11/13/2007 04:12 PM, Alan Cox wrote:
> >> Bug fixing is not about finding someone to blame, it's about getting the 
> >> bug fixed.
> > 
> > Partly - its also about understanding why the bug occurred and making it
> > not happen again.
> 
> Very few people think about that part.

Why does the kernel have very few useful tests?
 Lack of interest? resources? expertise?
Ideally each new feature would just be a small add on to an existing test.

Unlike developing new features which seems to grow well with more developers.
Bug fixing also seems to be a scarcity process. There often seems to be
a very few people that understand the problem well enough or have the necessary
hardware to reproduce and fix the problem.

Recent changes like tickless and scheduler rework were well thought out and caused
very little impact to 90% of the users. The problem is the 10% who do have problems.
Worse, the developers often only hear about the a small sample of those.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
