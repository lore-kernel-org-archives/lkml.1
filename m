Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbYF2Ptm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbYF2Ptm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 11:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYF2Ptb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 11:49:31 -0400
Received: from mk-outboundfilter-5.mail.uk.tiscali.com ([212.74.114.1]:28620
	"EHLO mk-outboundfilter-5.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752454AbYF2Ptb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 11:49:31 -0400
X-Trace: 50941259/mk-outboundfilter-5.mail.uk.tiscali.com/F2S/$ACCEPTED/freedom2Surf-customers/195.137.94.162
X-SBRS: None
X-RemoteIP: 195.137.94.162
X-IP-MAIL-FROM: spyro@f2s.com
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqoAAMtLZ0jDiV6i/2dsb2JhbAAIrj8
X-IronPort-AV: E=Sophos;i="4.27,722,1204502400"; 
   d="scan'208";a="50941259"
X-IP-Direction: IN
Subject: Re: [PATCH] w100fb: add 80 MHz modeline
From: ian <spyro@f2s.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alberto Mardegan <mardy@users.sourceforge.net>,
       Richard Purdie <rpurdie@rpsys.net>
In-Reply-To: <1214747627.2758.1.camel@localhost.localdomain>
References: <1214747627.2758.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 29 Jun 2008 16:49:27 +0100
Message-Id: <1214754567.8407.52.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-29 at 15:53 +0200, Philipp Zabel wrote:

Looks fine to me.   'lock time' looks a bit low but since the PLL is
very poorly understood (I wrote the c based on winCE disassembly) if it
works, go for it.

> This is needed for HTC Blueangel (w3200).
> At 96MHz its screen flickers.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>

  Acked-by: Ian Molton <spyro@f2s.com>

> ---
>  drivers/video/w100fb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/w100fb.c b/drivers/video/w100fb.c
> index 30469bf..3e48eef 100644
> --- a/drivers/video/w100fb.c
> +++ b/drivers/video/w100fb.c
> @@ -1003,6 +1003,7 @@ static struct w100_pll_info xtal_14318000[] = {
>  static struct w100_pll_info xtal_16000000[] = {
>  	/*freq     M   N_int    N_fac  tfgoal  lock_time */
>  	{ 72,      1,   8,       0,     0xe0,        48}, /* tfgoal guessed */
> +	{ 80,      1,   9,       0,     0xe0,        13}, /* tfgoal guessed */
>  	{ 95,      1,   10,      7,     0xe0,        38}, /* tfgoal guessed */
>  	{ 96,      1,   11,      0,     0xe0,        36}, /* tfgoal guessed */
>  	{  0,      0,   0,       0,        0,         0},

