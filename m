Return-Path: <linux-kernel-owner+w=401wt.eu-S1757087AbYGBObU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbYGBObU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 10:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbYGBObH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 10:31:07 -0400
Received: from n24.bullet.mail.mud.yahoo.com ([68.142.206.163]:29863 "HELO
	n24.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754149AbYGBObG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 10:31:06 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jul 2008 10:31:06 EDT
X-Yahoo-Newman-Id: 393367.39998.bm@omp406.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
  b=Tn5W9LNB7bTLf9+eZOcoWrOwRz4cwEKw6PgJpUOyGKI2q3PIPOjNSkukd4d+JYUu+qlcE8z+3MBNaxgAlEByAkcw750uYcmgQhjKGk7JcKIdTg8ssZNOyj3kylNONP8iYyrL18XnzEvXLratVZmGADpajwhuJ6Xt9xeqx8wiev4=  ;
X-YMail-OSG: 1KtHUTcVM1mNgYxlxOdstS0r0iVtd_qHI79eTdoOZDeFg.mwccIMENnV7xY4fIdd3n3qxwafwXpXjSqlNM5smXc8C5DX_1IfXEkHYI8VuQ--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <486B8FCF.8080201@yahoo.it>
Date: Wed, 02 Jul 2008 16:25:19 +0200
From: Filippo Zangheri <filippo.zangheri@yahoo.it>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Darren Jenkins <darrenrjenkins@gmail.com>
CC: kernel Janitors <kernel-janitors@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, ipw2100-admin@linux.intel.com,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH]  drivers/net/wireless/iwlwifi/iwl-3945.c
References: <1214962647.18261.15.camel@localhost.localdomain>
In-Reply-To: <1214962647.18261.15.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.6
OpenPGP: id=6C1F2F2F;
	url=http://keyserver.fabbione.net:11371/pks/lookup?op=get&search=0x8F3C4C1B6C1F2F2F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc'ing linux-wireless)

On 02/07/2008 03:37, Darren Jenkins\ wrote:
> G'day people
> 
> Coverity CID: 2265 NEGATIVE_RETURNS
> 
> "rate" is of an unsigned type, and the code requires a signed type.
> The following patch makes it so.
> 
> Only compile tested.
> 
> ﻿Signed-off-by: Darren Jenkins <darrenrjenkins@gmailcom>
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
> index 62a3d8f..31d38cd 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> @@ -449,7 +449,7 @@ static void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
>  
>  	if (print_summary) {
>  		char *title;
> -		u32 rate;
> +		int rate;
>  
>  		if (hundred)
>  			title = "100Frames";

-- 
Filippo Zangheri

GPG key ID: 0x6C1F2F2F

