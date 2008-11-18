Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbYKRLxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbYKRLxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 06:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYKRLxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 06:53:33 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2466 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbYKRLxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 06:53:33 -0500
Date: Tue, 18 Nov 2008 11:53:29 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: tiwai@suse.de, Cliff Cai <cliff.cai@analog.com>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 4/8] ASoC: Blackfin: fix bug - AD1980/1 SOC Audio driver fails to build in case MMAP support is turned off
Message-ID: <20081118115328.GF23217@sirena.org.uk>
References: <1226996302-10234-1-git-send-email-cooloney@kernel.org> <1226996302-10234-5-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226996302-10234-5-git-send-email-cooloney@kernel.org>
X-Cookie: Be sure each item is properly endorsed.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 04:18:18PM +0800, Bryan Wu wrote:
> From: Cliff Cai <cliff.cai@analog.com>
> 
> clean up redudent code and correct building problem in non-mmap mode

This doesn't apply against 2.6.28 - does the same issue apply there?  If
so then a patch for 2.6.28 fixing *only* the build issue would probably
be a good idea.

Alos, please try to ensure that the short log for your patch is less
than 80 characters (it should normally be much less).
