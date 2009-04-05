Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbZDELB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbZDELB6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 07:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbZDELBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 07:01:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:35360 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401AbZDELBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 07:01:31 -0400
Subject: Re: ath9k becon loss messages
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Sujith <Sujith.Manoharan@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       linville@tuxdriver.com, Kalle Valo <kalle.valo@iki.fi>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <200904051136.15285.mb@bu3sch.de>
References: <1238923439.4120.9.camel@localhost.localdomain>
	 <200904051129.38904.mb@bu3sch.de>  <200904051136.15285.mb@bu3sch.de>
Content-Type: text/plain
Date: Sun, 05 Apr 2009 16:30:33 +0530
Message-Id: <1238929233.5186.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-04-05 at 11:36 +0200, Michael Buesch wrote:
> On Sunday 05 April 2009 11:29:38 Michael Buesch wrote:
> > On Sunday 05 April 2009 11:23:59 Jaswinder Singh Rajput wrote:
> > > With latest linus tree I am getting, .config file attached:
> > > 
> > > [   22.895051] r8169: eth0: link down
> > > [   22.897564] ADDRCONF(NETDEV_UP): eth0: link is not ready
> > > [   22.928047] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> > > [   22.982292] libvirtd used greatest stack depth: 4200 bytes left
> > > [   63.709879] wlan0: authenticate with AP 00:11:95:9e:df:f6
> > > [   63.712096] wlan0: authenticated
> > > [   63.712127] wlan0: associate with AP 00:11:95:9e:df:f6
> > > [   63.726831] wlan0: RX AssocResp from 00:11:95:9e:df:f6 (capab=0x471 status=0 aid=1)
> > > [   63.726855] wlan0: associated
> > > [   63.730093] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> > > [   74.296087] wlan0: no IPv6 routers present
> > > [   79.349044] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [  119.358200] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [  179.354292] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [  259.366044] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [  359.348292] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [  361.953459] packagekitd used greatest stack depth: 4160 bytes left
> > > [  478.824258] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [  598.813343] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [  718.817292] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [  838.824567] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [  958.815402] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [ 1078.848434] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [ 1198.822913] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [ 1318.824931] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [ 1438.814157] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [ 1558.827336] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [ 1678.823011] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [ 1798.830589] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [ 1918.828044] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [ 2038.827224] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [ 2116.517152] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [ 2158.840243] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [ 2278.827427] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > 
> > 
> > I think this message should only show if CONFIG_MAC80211_VERBOSE_DEBUG is set.
> > It's kind of expected that we lose a beacon once in a while, so we shouldn't print
> > verbose messages to the kernel log (even if they are KERN_DEBUG).
> > 
> > And besides that, I think one can easily remotely trigger this message and flood the logs.
> > So it should probably _also_ be ratelimited.
> > 
> 

I tested you patch:
when CONFIG_MAC80211_VERBOSE_DEBUG was not defined:
[   21.928047] r8169: eth0: link down
[   21.930774] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   21.957007] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   59.872337] wlan0: authenticate with AP 00:11:95:9e:df:f6
[   59.874350] wlan0: authenticated
[   59.874350] wlan0: associate with AP 00:11:95:9e:df:f6
[   59.893103] wlan0: RX AssocResp from 00:11:95:9e:df:f6 (capab=0x471 status=0 aid=1)
[   59.893135] wlan0: associated
[   59.896260] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   70.409313] wlan0: no IPv6 routers present

when CONFIG_MAC80211_VERBOSE_DEBUG defined:
[   22.851052] r8169: eth0: link down
[   22.854049] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   22.885982] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   61.043261] wlan0: authenticate with AP 00:11:95:9e:df:f6
[   61.044997] wlan0: authenticated
[   61.045016] wlan0: associate with AP 00:11:95:9e:df:f6
[   61.059901] wlan0: RX AssocResp from 00:11:95:9e:df:f6 (capab=0x471 status=0 aid=1)
[   61.059922] wlan0: associated
[   61.060124] wlan0: switched to short barker preamble (BSSID=00:11:95:9e:df:f6)
[   61.060141] wlan0: switched to short slot time (BSSID=00:11:95:9e:df:f6)
[   61.064651] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   71.211042] wlan0: no IPv6 routers present
[   79.323009] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[  119.333646] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[  179.332725] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[  259.330506] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[  359.311615] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[  479.334949] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[  599.330222] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[  719.001652] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[  838.994788] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[  958.993262] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 1079.024024] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 1199.023672] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 1319.021355] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
..

So net_ratelimit() does not make any difference in my case where rate is 120 seconds.

--
JSR

> Something like this:
> 
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> Index: wireless-testing/net/mac80211/mlme.c
> ===================================================================
> --- wireless-testing.orig/net/mac80211/mlme.c	2009-04-05 11:32:16.000000000 +0200
> +++ wireless-testing/net/mac80211/mlme.c	2009-04-05 11:35:57.000000000 +0200
> @@ -945,9 +945,13 @@ void ieee80211_beacon_loss_work(struct w
>  			     u.mgd.beacon_loss_work);
>  	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
>  
> -	printk(KERN_DEBUG "%s: driver reports beacon loss from AP %pM "
> -	       "- sending probe request\n", sdata->dev->name,
> -	       sdata->u.mgd.bssid);
> +#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
> +	if (net_ratelimit()) {
> +		printk(KERN_DEBUG "%s: driver reports beacon loss from AP %pM "
> +		       "- sending probe request\n", sdata->dev->name,
> +		       sdata->u.mgd.bssid);
> +	}
> +#endif
>  
>  	ifmgd->flags |= IEEE80211_STA_PROBEREQ_POLL;
>  	ieee80211_send_probe_req(sdata, ifmgd->bssid, ifmgd->ssid,
> @@ -1007,9 +1011,13 @@ static void ieee80211_associated(struct 
>  	      (local->hw.conf.flags & IEEE80211_CONF_PS)) &&
>  	    time_after(jiffies,
>  		       ifmgd->last_beacon + IEEE80211_MONITORING_INTERVAL)) {
> -		printk(KERN_DEBUG "%s: beacon loss from AP %pM "
> -		       "- sending probe request\n",
> -		       sdata->dev->name, ifmgd->bssid);
> +#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
> +		if (net_ratelimit()) {
> +			printk(KERN_DEBUG "%s: beacon loss from AP %pM "
> +			       "- sending probe request\n",
> +			       sdata->dev->name, ifmgd->bssid);
> +		}
> +#endif
>  		ifmgd->flags |= IEEE80211_STA_PROBEREQ_POLL;
>  		ieee80211_send_probe_req(sdata, ifmgd->bssid, ifmgd->ssid,
>  					 ifmgd->ssid_len, NULL, 0);
> 

