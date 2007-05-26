Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbXEZXFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbXEZXFa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 19:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbXEZXFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 19:05:21 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45044
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbXEZXFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 19:05:21 -0400
From: Michael Buesch <mb@bu3sch.de>
To: divy@chelsio.com
Subject: Re: [PATCH 4/7] cxgb3 - Update FW to 4.1
Date: Sun, 27 May 2007 01:05:09 +0200
User-Agent: KMail/1.9.6
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
References: <20070526230003.12156.10521.stgit@localhost.localdomain>
In-Reply-To: <20070526230003.12156.10521.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705270105.10188.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 May 2007 01:00:04 divy@chelsio.com wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> Bump FW version to 4.1.
> Modify chip tuning in consequence.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---

> @@ -2496,11 +2500,11 @@ static void __devinit init_mtus(unsigned
>  	 * it can accomodate max size TCP/IP headers when SACK and timestamps
>  	 * are enabled and still have at least 8 bytes of payload.
>  	 */
> -	mtus[0] = 88;
> -	mtus[1] = 256;
> -	mtus[2] = 512;
> -	mtus[3] = 576;
> -	mtus[4] = 808;
> +	mtus[1] = 88;
> +	mtus[1] = 88;

looks like a typo.

> +	mtus[2] = 256;
> +	mtus[3] = 512;
> +	mtus[4] = 576;
>  	mtus[5] = 1024;
>  	mtus[6] = 1280;
>  	mtus[7] = 1492;

-- 
Greetings Michael.
