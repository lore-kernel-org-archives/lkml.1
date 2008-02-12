Return-Path: <linux-kernel-owner+w=401wt.eu-S1760212AbYBLPNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212AbYBLPNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756940AbYBLPNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:13:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38133 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926AbYBLPNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:13:24 -0500
Date: Tue, 12 Feb 2008 16:12:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 1/2] acer-wmi - Fail gracefully if ACPI is disabled
Message-ID: <20080212151225.GA5415@elte.hu>
References: <200802080145.16774.lenb@kernel.org> <20080211091743.GA16459@elte.hu> <200802111923.31736.carlos@strangeworlds.co.uk> <200802111955.04562.carlos@strangeworlds.co.uk> <alpine.LFD.1.00.0802112038360.2920@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802112038360.2920@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> @@ -673,11 +673,11 @@ static int __init acpi_wmi_init(void)
>  {
>  	acpi_status result;
>  
> +	INIT_LIST_HEAD(&wmi_blocks.list);
> +
>  	if (acpi_disabled)
>  		return -ENODEV;
>  
> -	INIT_LIST_HEAD(&wmi_blocks.list);
> -

test results: i've turned the WMI options back on earlier today on 
latest -git which has your patch above, and those crashes i reported 
disappeared. So the problem is fixed.

	Ingo
