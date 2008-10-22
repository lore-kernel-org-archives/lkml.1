Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbYJVCpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbYJVCpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 22:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbYJVCpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 22:45:24 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:45464 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbYJVCpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 22:45:23 -0400
Message-ID: <48FE93C1.6030407@lwfinger.net>
Date: Tue, 21 Oct 2008 19:45:21 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Jouni Malinen <jouni.malinen@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 2.6.27-git from commit 43ac2ca3840f64
References: <48FDFCCA.8040604@lwfinger.net> <20081021213723.GL17268@tuxdriver.com>
In-Reply-To: <20081021213723.GL17268@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John W. Linville wrote:
> From: John W. Linville <linville@tuxdriver.com>
> Subject: [PATCH] mac80211: do not aggregate IEs from scan results
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  net/mac80211/scan.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index 416bb41..51ed74d 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -728,8 +728,6 @@ static void ieee80211_scan_add_ies(struct iw_request_info *info,
>  
>  	while (end - pos > IW_GENERIC_IE_MAX) {
>  		next = pos + 2 + pos[1];
> -		while (next + 2 + next[1] - pos < IW_GENERIC_IE_MAX)
> -			next = next + 2 + next[1];
>  
>  		memset(&iwe, 0, sizeof(iwe));
>  		iwe.cmd = IWEVGENIE;

No, this patch does not fix the problem.

Larry
