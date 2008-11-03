Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYKCCpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYKCCpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 21:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYKCCpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 21:45:24 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:2502 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbYKCCpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 21:45:23 -0500
Date: Sun, 2 Nov 2008 21:44:55 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: jirislaby@gmail.com, ath5k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       michael+ath5k@stapelberg.de, linville@tuxdriver.com
Subject: Re: [ath5k-devel] [PATCH] ath5k: fix detection of jumbo frames
Message-ID: <20081103024455.GA11462@hash.localnet>
References: <1225652938-6244-1-git-send-email-me@bobcopeland.com> <43e72e890811021300o6bef49b0i515d0f72974cef00@mail.gmail.com> <20081102215218.GA6203@hash.localnet> <43e72e890811021433q61fe925bt5817f9e1ab0ba581@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890811021433q61fe925bt5817f9e1ab0ba581@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2008 at 02:33:44PM -0800, Luis R. Rodriguez wrote:
> > Not sure I follow - these are incoming frames, which all had a status_0
> > of 0x1a40 (rs_more=0x1000 & length=0xa40).  So hw rate index was zero
> > on these for some reason, but in my testing the rate index of all other
> > packets was something reasonable, e.g. 0x27.
> 
> Interesting -- I will have to check on what this means.

Yup, it would be good to handle these properly.

-- 
Bob Copeland %% www.bobcopeland.com

