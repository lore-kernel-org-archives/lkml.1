Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbYBTGpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbYBTGpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 01:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYBTGpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 01:45:22 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:19172 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbYBTGpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 01:45:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=b2BpRp/y6zd5pkysARXm65sLdW4rp5XZ/axI3+fagVAuWvt3BPE7gHwtzMdwsfBsBf5HZ5BghR48QU0L5GemRNpPKs+s9nKcBdn2kFKCT9mXuy28wtA5yRhxIcsN7j3JimJgbuB5DuvH94xd0NlIzFYmmakkyVWESc8GakqouWQ=
Date: Wed, 20 Feb 2008 06:46:13 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.25 patch] fix broken error handling in
	ieee80211_sta_process_addba_request()
Message-ID: <20080220064613.GA3885@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219225852.GQ31955@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19-02-2008 23:58, Adrian Bunk wrote:
...
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -1116,9 +1116,10 @@ static void ieee80211_sta_process_addba_request(struct net_device *dev,
...
> +			printk(KERN_ERR "can not allocate reordering buffer "

  +			printk(KERN_ERR "cannot allocate reordering buffer "

Probably this can be fixed during the commit.

Jarek P.
