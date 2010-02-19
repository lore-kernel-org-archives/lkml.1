Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab0BSBsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 20:48:24 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:41507 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab0BSBsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 20:48:22 -0500
To: Richard Hartmann <richih.mailinglist@gmail.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Gilbert <bgilbert@cs.cmu.edu>, linux-kernel@vger.kernel.org
References: <1266538925-3245-1-git-send-email-richih.mailinglist@gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 18 Feb 2010 17:48:14 -0800
In-Reply-To: <1266538925-3245-1-git-send-email-richih.mailinglist@gmail.com> (Richard Hartmann's message of "Fri\, 19 Feb 2010 01\:22\:03 +0100")
Message-ID: <m1d402t2qp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Richard Hartmann <richih.mailinglist@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 05/19] crypto: proc - Fix checkpatch errors
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Hartmann <richih.mailinglist@gmail.com> writes:

>  	seq_printf(m, "name         : %s\n", alg->cra_name);
>  	seq_printf(m, "driver       : %s\n", alg->cra_driver_name);
>  	seq_printf(m, "module       : %s\n", module_name(alg->cra_module));
>  	seq_printf(m, "priority     : %d\n", alg->cra_priority);
>  	seq_printf(m, "refcnt       : %d\n", atomic_read(&alg->cra_refcnt));
>  	seq_printf(m, "selftest     : %s\n",
> -		   (alg->cra_flags & CRYPTO_ALG_TESTED) ?
> -		   "passed" : "unknown");
> +	           (alg->cra_flags & CRYPTO_ALG_TESTED) ?
> +	           "passed" : "unknown");

Why did you replaced a tab with spaces here??


Eric
