Return-Path: <linux-kernel-owner+w=401wt.eu-S1758933AbYGQS2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbYGQS2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758239AbYGQS2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:28:17 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:57133 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758183AbYGQS2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:28:16 -0400
Date: Thu, 17 Jul 2008 19:27:52 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: MMC: s3cmci: ensure host stopped on machine shutdown
Message-ID: <20080717182752.GJ24620@fluff.org.uk>
References: <20080717143253.823429733@fluff.org.uk> <20080717172945.3481eefa@mjolnir.drzeus.cx> <20080717155037.GI24620@fluff.org.uk> <20080717182242.598ff68a@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717182242.598ff68a@mjolnir.drzeus.cx>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 06:22:42PM +0200, Pierre Ossman wrote:
> On Thu, 17 Jul 2008 16:50:37 +0100
> Ben Dooks <ben-linux@fluff.org> wrote:
> 
> > On Thu, Jul 17, 2008 at 05:29:45PM +0200, Pierre Ossman wrote:
> > > 
> > > The core can send requests your way until mmc_remove_host() returns so
> > > you can't remove the interrupt before then.
> > 
> > I'm only removing the card-detect interrupt, the main host one
> > is not being disabled here.
> > 
> 
> Ah, I see. Then it should be just fine. I'll have it queued up.

It does depend on the previous patch to fix the section
mismatch reports.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
