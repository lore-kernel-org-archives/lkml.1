Return-Path: <linux-kernel-owner+w=401wt.eu-S1758991AbZFJLfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991AbZFJLfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 07:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbZFJLfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 07:35:12 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:4735 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227AbZFJLfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 07:35:11 -0400
Date: Wed, 10 Jun 2009 07:34:06 -0400
From: Bob Copeland <me@bobcopeland.com>
To: William Thompson <wt@electro-mechanical.com>
Cc: linux-kernel@vger.kernel.org, ath5k-devel <ath5k-devel@venema.h4ckr.net>
Subject: Re: 3com 3crxjk10075 with ath5k driver
Message-ID: <20090610113406.GE19635@hash.localnet>
References: <20090609195100.GY19203@electro-mechanical.com> <b6c5339f0906091339j3784c36bxe888af16272fbcde@mail.gmail.com> <20090610112357.GB19203@electro-mechanical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610112357.GB19203@electro-mechanical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 07:23:57AM -0400, William Thompson wrote:
> > I suppose it could be asserting something on rfkill gpios; ath5k hasn't had
> > real rfkill support yet.  Anyone else know about these devices?
> 
> It's possible.  The LED on it goes off when it's pushed in.  Which reminds
> me, I don't think the ath5k driver allows the LED to blink when it's
> transmitting/receiving, it just stays on.

Can you try latest wireless-testing?  There's an rfkill patch for
ath5k in it.  URL is:

git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git

As for LEDs, there's a patch in kernel bugzilla.  I don't have a link handy
but you can check the ath5k-devel archives from a week or two ago, let
me know if you can't find it.

-- 
Bob Copeland %% www.bobcopeland.com

