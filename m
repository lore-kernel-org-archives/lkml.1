Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbZGWSe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbZGWSe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbZGWSe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:34:56 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:51133 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbZGWSe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:34:56 -0400
Date: Thu, 23 Jul 2009 20:34:51 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ian Molton <spyro@f2s.com>, Anton Vorontsov <cbou@mail.ru>,
       Matt Reimer <mreimer@vpop.net>
Subject: Re: [PATCH 1/3] pda-power: add set_charged functionaltity
Message-ID: <20090723183451.GI13236@buzzloop.caiaq.de>
References: <1247759044-4747-1-git-send-email-daniel@caiaq.de> <20090720182752.GA20602@oksana.dev.rtsoft.ru> <20090720183711.GF19257@buzzloop.caiaq.de> <20090720190034.GA24617@oksana.dev.rtsoft.ru> <20090722172045.GH13236@buzzloop.caiaq.de> <20090722174111.GA14636@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090722174111.GA14636@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 09:41:11PM +0400, Anton Vorontsov wrote:
> On Wed, Jul 22, 2009 at 07:20:45PM +0200, Daniel Mack wrote:
> > What about something like the patch below?
> > 
> > The platform code interface would look like
> > 
> > 	struct power_supply *psy =
> > 		power_support_get_by_name("ds2760.0");
> > 	if (psy)
> > 		power_supply_set_battery_charged(psy);
> > 
> > Couldn't test it yet as my hardware is missing, but I would still like
> > to hear your comments about it :)
> 
> Wow, looks perfect. Let me know when you test it, and I'll
> apply that patch.

That seems to work well. I'm still resending the last two remaining
patches as a follow-up to this one - the changelog had a typo.

Thanks,
Daniel

