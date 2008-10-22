Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbYJVRGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbYJVRGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYJVRFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:05:49 -0400
Received: from hostap.isc.org ([149.20.54.63]:35215 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbYJVRFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:05:48 -0400
Date: Wed, 22 Oct 2008 20:04:44 +0300
From: Jouni Malinen <j@w1.fi>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       John Linville <linville@tuxdriver.com>
Subject: Re: Regression in 2.6.27-git from commit 43ac2ca3840f64
Message-ID: <20081022170444.GH16005@jm.kir.nu>
References: <48FDFCCA.8040604@lwfinger.net> <20081022072840.GD16005@jm.kir.nu> <48FF5933.3080501@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FF5933.3080501@lwfinger.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Spam-Score: -3.1
X-Spam-Bar: ---
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 09:47:47AM -0700, Larry Finger wrote:

> When a utility starts spitting messages that it doesn't understand what the
> kernel is providing _AND_ the commit message does not mention that this will
> happen, can someone be blamed for thinking it is a bug?

But the utility here understands that it receives additional IEs; it
just does not know the name or format for them. I do not understand why
the commit message should have commented on any particular user space
tool and their behavior as long as nothing is broken (and as far as I'm
aware, nothing was broken by that change).

> Clearly this is not a regression. Are there plans to update the wireless utilities?

Update them (or well, iwlist) to do what? Sure, it could have a list of
some additional known SSIDs, but that does not sound very useful. If the
"IE: Unknown" part is really making this somehow horrible for users, I
would just hide those lines by default (but there should be an option to
enable them). Anyway, I do not have any plans on providing a patch to
change iwlist behavior because I think the current behavior is
desirable.

-- 
Jouni Malinen                                            PGP id EFC895FA
