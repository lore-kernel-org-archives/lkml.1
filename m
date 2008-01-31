Return-Path: <linux-kernel-owner+w=401wt.eu-S932920AbYAaQNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920AbYAaQNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759131AbYAaQMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:12:54 -0500
Received: from www.tglx.de ([62.245.132.106]:35407 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758183AbYAaQMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:12:54 -0500
Date: Thu, 31 Jan 2008 17:12:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [7/9] Add an option to disable direct mapping gbpages
 and a global variable
In-Reply-To: <20080129050635.B5A7C1B416E@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0801311711130.9204@apollo.tec.linutronix.de>
References: <20080129606.610336873@suse.de> <20080129050635.B5A7C1B416E@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Andi Kleen wrote:
> +int direct_gbpages;
> +
> +static int __init parse_direct_gbpages(char *arg)
> +{
> +	if (!strcmp(arg, "off")) {
> +		direct_gbpages = -1;
> +		return 0;
> +	}
> +	return -1;
> +}
> +early_param("direct_gbpages", parse_direct_gbpages);

Can we please use simple boolean logic ? This 0, -1, 1 magic is more
than confusing.

Thanks,
	tglx
