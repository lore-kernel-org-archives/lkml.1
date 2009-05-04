Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbZEDRUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbZEDRUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbZEDRTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:19:54 -0400
Received: from nbd.name ([88.198.39.176]:44370 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbZEDRTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:19:53 -0400
X-Greylist: delayed 2329 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 May 2009 13:19:53 EDT
Message-ID: <49FF1A9B.9000608@openwrt.org>
Date: Mon, 04 May 2009 18:40:59 +0200
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: minstrel, fix memory corruption
References: <1241453096-8517-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1241453096-8517-1-git-send-email-jirislaby@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> minstrel doesn't count max rate count in fact, since it doesn't use
> a loop variable `i' and hence allocs space only for bitrates found in
> the first band.
> 
> Fix it by involving the `i' as an index so that it traverses all the
> bands now and finds the real max bitrate count.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Felix Fietkau <nbd@openwrt.org>
Good catch!

Acked-by: Felix Fietkau <nbd@openwrt.org>
