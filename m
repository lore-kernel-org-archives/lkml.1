Return-Path: <linux-kernel-owner+w=401wt.eu-S1161048AbXCGHM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161048AbXCGHM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:12:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161077AbXCGHM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:12:27 -0500
Received: from smtp-out.google.com ([216.239.45.13]:38827 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161048AbXCGHM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:12:26 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=QUitCGm2JOT85Bh2dPR7Za2MnF9zrdSxBNSsc2cFh9lKJlAdyQ1H0V2Gw3ovzqbnV
	fDonOzJNrQZy2EuQgD5jg==
Date: Tue, 6 Mar 2007 23:11:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@redhat.com>
cc: Dominik Brodowski <linux@brodo.de>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.21-rc3] cpufreq: p4-clockmod.c compilation error
In-Reply-To: <20070307065458.GA15453@redhat.com>
Message-ID: <Pine.LNX.4.64.0703062310130.12085@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0703062230001.1819@chino.kir.corp.google.com>
 <20070307065458.GA15453@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007, Dave Jones wrote:

> diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
> index d155e81..74747d9 100644
> --- a/drivers/cpufreq/Kconfig
> +++ b/drivers/cpufreq/Kconfig
> @@ -16,7 +16,7 @@ config CPU_FREQ
>  if CPU_FREQ
>  
>  config CPU_FREQ_TABLE
> -       tristate
> +       bool
>  
>  config CPU_FREQ_DEBUG
>         bool "Enable CPUfreq debugging"
> 
> 
> 

That did the trick, thanks.

Acked-by: David Rientjes <rientjes@google.com>
