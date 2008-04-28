Return-Path: <linux-kernel-owner+w=401wt.eu-S937508AbYD1UDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937508AbYD1UDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934804AbYD1UCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:02:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56516 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934258AbYD1UCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:02:36 -0400
Date: Mon, 28 Apr 2008 22:02:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Markus Metzger <markus.t.metzger@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: DS cleanup - dont treat 0 as NULL
Message-ID: <20080428200220.GA15840@elte.hu>
References: <20080428191504.GA6842@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428191504.GA6842@cvg>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

thanks Cyrill, applied.

> @@ -825,7 +825,7 @@ void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
>  			ds_configure(&ds_cfg_var);
>  			break;
>  		case 0xF: /* Core2 */
> -        case 0x1C: /* Atom */
> +		case 0x1C: /* Atom */
>  			ds_configure(&ds_cfg_64);
>  			break;

to me it looks like a typo, not a sign of any real bug/thinko. The 
processor IDs there are a flat list.

	Ingo
