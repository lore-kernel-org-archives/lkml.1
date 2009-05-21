Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbZEUAeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbZEUAeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756925AbZEUAeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:34:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37619
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756730AbZEUAeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:34:09 -0400
Date: Wed, 20 May 2009 17:34:08 -0700 (PDT)
Message-Id: <20090520.173408.126761158.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-05-20
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090520193446.GA27441@tuxdriver.com>
References: <20090520193446.GA27441@tuxdriver.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 20 May 2009 15:34:47 -0400

> Another volley of fixes intended for 2.6.30 -- I know the velocity
> is a bit high for this part of the cycle, but these are mostly small
> and well-tested.
> 
> The one from me is a "brown paper bag" fix.  My earlier attempt to fix
> the potential buffer overflow in airo was actually a no-op due to an
> (unknown to me) type overflow... :-(
> 
> The ath5k fixes from Forrest Zhang and Pavel Roskin together fix some
> regressions with 5GHz operation.  The one from Fabio Rossi avoids an
> infinite loop reported by Stephen Rostedt.
> 
> The wext fix addresses a possible buffer overflow.  The cfg80211 fix
> addresses a user-reported oops.  The one from Roel avoids and index
> past the end of an array.
> 
> One of iwlwifi patches avoids a deadlock.  The other iwlwifi patch
> simply enables the use of the firmware image they just released.
> That one is worth taking for 2.6.30 because the new firmware fixes
> a couple of bugs that show-up as kernel bug reports.
> 
> Please let me know if there are problems!

Pulled, thanks John!
