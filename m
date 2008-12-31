Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbYLaOGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbYLaOGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 09:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbYLaOGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 09:06:40 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:3505 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbYLaOGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 09:06:39 -0500
Date: Wed, 31 Dec 2008 09:06:11 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org
Subject: Re: [ath5k-devel] Bugs on aspire one A150
Message-ID: <20081231140611.GB26600@hash.localnet>
References: <1230641016.5770.5.camel@maxim-laptop> <20081231091845.GA2516@rhlx01.hs-esslingen.de> <20081231135914.GA31780@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231135914.GA31780@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 02:59:15PM +0100, Andreas Mohr wrote:
> IOW, our hardware _is_ inverted for real I believe and the driver needs
> to be fixed.

Ok please try the change I suggested in the other email.

> Oh, and what about the second LED on the left side? That one would be
> available for driver implementation, too, right?
> Or is that one hard-wired (via Embedded Controller?)
> to rfkill mechanical switch?

Every laptop is wired differently (in my case I don't even have an LED).
So, you can experiment with different gpios to see if the other LED will
work.  Right now the driver only supports a single led pin but it
wouldn't be hard to change.

-- 
Bob Copeland %% www.bobcopeland.com

