Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbZCFLUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbZCFLUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 06:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZCFLUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 06:20:40 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1382 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZCFLUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 06:20:39 -0500
Date: Fri, 6 Mar 2009 11:10:03 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
Message-ID: <20090306110949.GC6493@sirena.org.uk>
References: <1236326010-683-1-git-send-email-cooloney@kernel.org> <1236326010-683-5-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236326010-683-5-git-send-email-cooloney@kernel.org>
X-Cookie: Q: How do you keep a moron in suspense?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH 4/5] ASoC: Blackfin: drop pointless casts
	due to dma updates
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 03:53:29PM +0800, Bryan Wu wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  sound/blackfin/bf53x_sport.c |   55 ++++++++++++++++++-----------------------
>  1 files changed, 24 insertions(+), 31 deletions(-)

Mainline doesn't have a sound/blackfin directory at all as far as I can
tell so this patch doesn't apply?  The only mainline support I can see
for blackfin audio is sound/soc/blackfin which only has a generic
bf5xx-sport file.  A similar cleanup was done there a while ago.
