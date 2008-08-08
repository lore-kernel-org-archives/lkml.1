Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbYHHBZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbYHHBZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 21:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYHHBZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 21:25:12 -0400
Received: from 175.212.DSNET ([203.110.175.212]:3054 "EHLO mail.atheros.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752673AbYHHBZL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 21:25:11 -0400
From: Jie Yang <Jie.Yang@Atheros.com>
To: roel kluin <roel.kluin@gmail.com>,
       "jgarzik@redhat.com" <jgarzik@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 8 Aug 2008 09:25:09 +0800
Subject: RE: [PATCH?] atl1e: WAKE_MCAST 2x. 1st WAKE_UCAST?
Thread-Topic: [PATCH?] atl1e: WAKE_MCAST 2x. 1st WAKE_UCAST?
Thread-Index: Acj4eP9gvbaPqdPGQCmW1E/15SYX/QAfFmIg
Message-ID: <72981EBCFD196144B7C6999B9FC34A9A3EE61F98F7@SHEXMB-01.global.atheros.com>
References: <489B21CA.7010508@gmail.com>
In-Reply-To: <489B21CA.7010508@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 08, 2008 12:25 AM
roel kluin <roel.kluin@gmail.com> wrote:
> untested, is it right?
> ---
> WAKE_MCAST bit tested twice, test WAKE_UCAST first.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com> diff --git
> a/drivers/net/atl1e/atl1e_ethtool.c
> b/drivers/net/atl1e/atl1e_ethtool.c
> index cdc3b85..619c658 100644
> --- a/drivers/net/atl1e/atl1e_ethtool.c
> +++ b/drivers/net/atl1e/atl1e_ethtool.c
> @@ -355,7 +355,7 @@ static int atl1e_set_wol(struct
> net_device *netdev, struct ethtool_wolinfo *wol)
>         struct atl1e_adapter *adapter = netdev_priv(netdev);
>
>         if (wol->wolopts & (WAKE_ARP | WAKE_MAGICSECURE |
> -                           WAKE_MCAST | WAKE_BCAST | WAKE_MCAST))
> +                           WAKE_UCAST | WAKE_MCAST | WAKE_BCAST))
>                 return -EOPNOTSUPP;
>         /* these settings will always override what we
> currently have */
>         adapter->wol = 0;
>

Yes, It should be this! Thanks!

Best wishes
jie
