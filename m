Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbZEDLcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbZEDLcC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 07:32:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbZEDLbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 07:31:49 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:3355 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZEDLbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 07:31:48 -0400
X-Greylist: delayed 2033 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 May 2009 07:31:48 EDT
Date: Mon, 04 May 2009 19:57:39 +0900 (JST)
Message-Id: <20090504.195739.90161410.yoshfuji@linux-ipv6.org>
To: stlman@poczta.fm
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] Temporary IPv6 address asignment
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <49FE1E71.6090500@poczta.fm>
References: <49FE18C3.7040702@poczta.fm>
	<20090503.153428.07349534.davem@davemloft.net>
	<49FE1E71.6090500@poczta.fm>
Organization: USAGI Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <49FE1E71.6090500@poczta.fm> (at Mon, 04 May 2009 00:45:05 +0200), Lukasz Stelmach <stlman@poczta.fm> says:

> @@ -188,6 +189,7 @@ enum {
>  	DEVCONF_TEMP_PREFERED_LFT,
>  	DEVCONF_REGEN_MAX_RETRY,
>  	DEVCONF_MAX_DESYNC_FACTOR,
> +	DEVCONF_DESYNC_FACTOR,
>  	DEVCONF_MAX_ADDRESSES,
>  	DEVCONF_FORCE_MLD_VERSION,
>  	DEVCONF_ACCEPT_RA_DEFRTR,

(In addition to the issue regarding sysctl,)
please do not add new DEVCONF_xxx enum in the middle.

--yoshfuji
