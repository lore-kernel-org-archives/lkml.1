Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbZHILLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbZHILLV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 07:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbZHILLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 07:11:19 -0400
Received: from bu3sch.de ([62.75.166.246]:34153 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbZHILLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 07:11:04 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: Libertas: Association request to the driver failed
Date: Sun, 9 Aug 2009 13:10:56 +0200
User-Agent: KMail/1.9.9
Cc: Daniel Mack <daniel@caiaq.de>, "John W. Linville" <linville@tuxdriver.com>,
       libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090807191156.GS19257@buzzloop.caiaq.de> <20090809102417.GH13639@buzzloop.caiaq.de> <4A7EAED8.9090900@gmail.com>
In-Reply-To: <4A7EAED8.9090900@gmail.com>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908091310.56919.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 August 2009 13:11:20 Roel Kluin wrote:
> @@ -43,21 +44,21 @@ static int get_common_rates(struct lbs_private *priv,
>  	u16 *rates_size)
>  {
>  	u8 *card_rates = lbs_bg_rates;
> -	size_t num_card_rates = sizeof(lbs_bg_rates);
>  	int ret = 0, i, j;
> -	u8 tmp[30];
> +	u8 tmp[*rates_size * ARRAY_SIZE(lbs_bg_rates)];

Is it a good idea to use dynamic stack arrays in the kernel?
What about kmalloc for dynamic allocations?

-- 
Greetings, Michael.
