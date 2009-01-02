Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbZABJXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbZABJXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 04:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbZABJXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 04:23:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47320 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbZABJXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 04:23:45 -0500
Date: Fri, 2 Jan 2009 10:23:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Cyrill Gorcunov <gorcunov@openvz.org>, Len Brown <lenb@kernel.org>
Subject: Re: [patch 3/3] acpi: check for pxm_to_node_map overflow
Message-ID: <20090102092330.GB1975@elte.hu>
References: <20090102082717.810810508@gmail.com>> <495dd169.0437560a.1cd3.ffffd503@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495dd169.0437560a.1cd3.ffffd503@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> It is hardly (if ever) possible but in case of broken _PXM
> entry we could reach out of pxm_to_node_map array
> bounds in acpi_map_pxm_to_node() call. Lets check it
> (it's not that expensive and safe).
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Len Brown <lenb@kernel.org>
> ---
>  drivers/acpi/numa.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

just curious - how did you find this - code review or some tool help like 
Sparse output or a compiler warning?

	Ingo
