Return-Path: <linux-kernel-owner+w=401wt.eu-S1761389AbYCYXeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761389AbYCYXeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbYCYXeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:34:13 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:56725 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945AbYCYXeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:34:12 -0400
Date: Wed, 26 Mar 2008 00:33:56 +0100
From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "Adam J. Richter" <adam@yggdrasil.com>,
       Alexander Kjeldaas <astor@fast.no>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH -mm crypto] AES: remove crypto_fl_tab and replace
	crypto_il_tab with isb_tab
Message-ID: <20080325233356.GA2577@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
References: <1205210576.3676.7.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1205210576.3676.7.camel@caritas-dev.intel.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Huang, Ying | 2008-03-11 12:42:56 [+0800]:

>These changes reduce the encryption cache footprint to 50% and
>decryption cache footprint to 53.1%. The code size is increased
>slightly. On my Intel CORE micro-architecture CPU, there is almost no
>performance penalty.
According to the tcrypt numbers you've posted it is getting "slightly"
slower on encryption/decryption of 64+ bytes. How did you measure your
"almost no performance penalty"?

 Sebastian
