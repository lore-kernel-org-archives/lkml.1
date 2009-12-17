Return-Path: <linux-kernel-owner+w=401wt.eu-S934453AbZLQBGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934453AbZLQBGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762907AbZLQBGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:06:24 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41621 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762760AbZLQBGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:06:23 -0500
Date: Wed, 16 Dec 2009 20:01:15 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: Dan Williams <dcbw@redhat.com>, linux-kernel@vger.kernel.org,
       Holger Schurig <holgerschurig@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Maithili Hinge <maithili@marvell.com>,
       Kiran Divekar <dkiran@marvell.com>,
       Michael Hirsch <m.hirsch@raumfeld.com>, netdev@vger.kernel.org,
       libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] Libertas: fix buffer overflow in lbs_get_essid()
Message-ID: <20091217010114.GA2913@tuxdriver.com>
References: <1260936778-2096-1-git-send-email-daniel@caiaq.de>
 <1260982667.2179.9.camel@localhost.localdomain>
 <20091216231508.GX28375@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091216231508.GX28375@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 07:15:08AM +0800, Daniel Mack wrote:
> On Wed, Dec 16, 2009 at 08:57:47AM -0800, Dan Williams wrote:
> > On Wed, 2009-12-16 at 05:12 +0100, Daniel Mack wrote:
> > > The libertas driver copies the SSID buffer back to the wireless core and
> > > appends a trailing NULL character for termination. This is
> > > 
> > > a) unnecessary because the buffer is allocated with kzalloc and is hence
> > >    already NULLed when this function is called, and
> > > 
> > > b) for priv->curbssparams.ssid_len == 32, it writes back one byte too
> > >    much which causes memory corruptions.
> > > 
> > > Fix this by removing the extra write.
> > 
> > Acked-by: Dan Williams <dcbw@redhat.com>
> 
> Thanks, everyone. Who will care to pick an queue this one?

Is there some reason it wouldn't be me?

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
