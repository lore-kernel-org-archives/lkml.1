Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbYKRLyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbYKRLyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 06:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYKRLy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 06:54:29 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2475 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbYKRLy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 06:54:29 -0500
Date: Tue, 18 Nov 2008 11:54:26 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: tiwai@suse.de, Cliff Cai <cliff.cai@analog.com>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [alsa-devel] [PATCH 5/8] ASoC: Fix BUGS in Blackfin AC97 DAI
Message-ID: <20081118115426.GG23217@sirena.org.uk>
References: <1226996302-10234-1-git-send-email-cooloney@kernel.org> <1226996302-10234-6-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226996302-10234-6-git-send-email-cooloney@kernel.org>
X-Cookie: Be sure each item is properly endorsed.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 04:18:19PM +0800, Bryan Wu wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>

> sport_handle is a global and not allocated my kmalloc.

There's no reference to sport_handle in the patch...

> A probe function should have a clean return 0 path.

...only this.
