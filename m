Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbYJVIO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbYJVIO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 04:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbYJVIOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 04:14:34 -0400
Received: from hostap.isc.org ([149.20.54.63]:36014 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbYJVIOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 04:14:32 -0400
X-Greylist: delayed 2693 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2008 04:14:32 EDT
Date: Wed, 22 Oct 2008 10:28:40 +0300
From: Jouni Malinen <j@w1.fi>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       John Linville <linville@tuxdriver.com>
Subject: Re: Regression in 2.6.27-git from commit 43ac2ca3840f64
Message-ID: <20081022072840.GD16005@jm.kir.nu>
References: <48FDFCCA.8040604@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FDFCCA.8040604@lwfinger.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Spam-Score: -3.2
X-Spam-Bar: ---
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 09:01:14AM -0700, Larry Finger wrote:

> On my x86_64 system, the mainline 2.6.27-git kernel (v2.6.27-6030-g6da0b38)
> shows the following anomaly with the 'iwlist scan' command:
> 
>           Cell 03 - Address: 00:14:BF:85:49:FA
>                     ESSID:"lwfdjf"
>                     Mode:Master
>                     Channel:1
>                     Frequency:2.412 GHz (Channel 1)
>                     Quality=66/100  Signal level:-62 dBm  Noise level=-68 dBm
>                     Encryption key:on
>                     IE: Unknown: 00066C7766646A66

...

> This problem was bisected to commit 43ac2ca3840f64f699a239535c590fa7ebaaac27,
> entitled "mac80211: Handle scan result IEs in one block". The same bug is
> present in the wireless-testing tree.

Problem? Bug? This is by design. What does not work for you?

-- 
Jouni Malinen                                            PGP id EFC895FA
