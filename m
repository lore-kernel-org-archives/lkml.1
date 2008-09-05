Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbYIEKSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbYIEKSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 06:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbYIEKSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 06:18:01 -0400
Received: from ocean.emcraft.com ([213.221.7.182]:51439 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbYIEKR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 06:17:59 -0400
Message-ID: <48C10732.1050009@emcraft.com>
Date: Fri, 05 Sep 2008 14:17:22 +0400
From: Ilya Yanok <yanok@emcraft.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, wd@denx.de, yur@emcraft.com
Subject: Re: [PATCH] ASYNC_TX: fix the bug in async_tx_run_dependencies
References: <1220478231-8725-1-git-send-email-yanok@emcraft.com>	 <20080904141945.f5c4c3eb.akpm@linux-foundation.org>	 <e9c3a7c20809041624o24af57fsbe58507a44e6e2ef@mail.gmail.com> <e9c3a7c20809041703h5bf6a007g6dcbe8fb2a5deffd@mail.gmail.com>
In-Reply-To: <e9c3a7c20809041703h5bf6a007g6dcbe8fb2a5deffd@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: Spam detection software, running on the system "ocean.emcraft.com", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Hello, Dan Williams wrote: > Please also take a look at
	this cleanup patch that I will queue for > .28. I think it makes things
	easier to read let me know if you > disagree. > Look good for me. Hmm,
	actually I don't think that current version is so hard to read... [...] 
	Content analysis details:   (-4.4 points, 2.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Dan Williams wrote:
> Please also take a look at this cleanup patch that I will queue for
> .28.  I think it makes things easier to read let me know if you
> disagree.
>   

Look good for me. Hmm, actually I don't think that current version is so
hard to read...

Just one comment:

> -	if (!next)
> +	if (dep)
> +		chan = dep->chan;
> +	else
>  		return;
>   

I don't like 'return' inside 'else'.

Regards, Ilya.

