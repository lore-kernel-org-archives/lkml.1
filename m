Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbYK0PHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbYK0PHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYK0PHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:07:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34195 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbYK0PHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:07:39 -0500
Date: Thu, 27 Nov 2008 16:07:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com,
       matthew@wil.cx
Subject: Re: [PATCH v2 2/2] relatime: Allow making relatime the default
	behaviour
Message-ID: <20081127150723.GD10188@elte.hu>
References: <20081126195457.GA3541@srcf.ucam.org> <20081126195824.GB3541@srcf.ucam.org> <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127150341.GB20941@srcf.ucam.org>
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


* Matthew Garrett <mjg@redhat.com> wrote:

> Add support for defaulting to relatime
>     
> Allow the kernel to enable relatime on all mounts by default. This can be
> configured at build time or by a kernel parameter or sysctl. Also add a
> MS_NORELATIME mount option to allow the default to be overridden for specific
> mount points.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> ---
> 
> Incorporates Randy's suggestion to change default_relatime to 
> relatime_default, along with a couple of typographical fixes

> +config DEFAULT_RELATIME
> +	bool "Mount all filesystems with relatime by default"
> +	default y

This should not be enabled by default - but distros can set it to 
enabled just fine.

Looks good otherwise!

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
