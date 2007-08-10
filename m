Return-Path: <linux-kernel-owner+w=401wt.eu-S932431AbXHJKZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbXHJKZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 06:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757067AbXHJKZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 06:25:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:33676 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794AbXHJKZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 06:25:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Slofvjma8aD27bXMMLa/d0WhV5mBhpMpU0P64sUyt75rBI6Uf/Y9dzwdcg9DxMX+MaN+nDs3wIjyjxITWeQAO1j0FoJM0nGI+X0OqODPf2WSrejii8slNvtYDIORS+JPjalO5Sr7we3wCOApJO8Nin+3uB0PIAhPJ3O1OD/6+BI=
Message-ID: <46BC3CB1.2090503@googlemail.com>
Date: Fri, 10 Aug 2007 12:23:45 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: 2.6.23-rc2-mm2
References: <20070809224254.11f42716.akpm@linux-foundation.org>
In-Reply-To: <20070809224254.11f42716.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

...

> +sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
> +sysctl-factor-out-sysctl_data.patch
> +sysctl-error-on-bad-sysctl-tables.patch
> +sysctl-update-sysctl_check_table.patch
> +sysct-mqueue-remove-the-binary-sysctl-numbers.patch
> +sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
> +sysctl-fix-neighbour-table-sysctls.patch
> +sysctl-ipv6-route-flushing-kill-binary-path.patch
> +sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
> +sysctl-x86_64-remove-unnecessary-binary-paths.patch
> +sysctl-remove-broken-cdrom-binary-sysctls.patch
> +sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
> +sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
> 
>  sysctl cleanups
> 

...


Getting all this on boot :

...

[  484.984331] sysctl table check failed: /dev/parport/default/timeslice .7.3.-3.1 Missing strategy
[  484.984515] sysctl table check failed: /dev/parport/default/spintime .7.3.-3.2 Missing strategy
[  485.001254] sysctl table check failed: /dev/parport/parport0/devices/Device ID probe .7.3.1.6.1 Directory with extra1
[  485.001472] sysctl table check failed: /dev/parport/parport0/devices/Device ID probe/timeslice .7.3.1.6.1.1 Missing strategy
[  485.042786] sysctl table check failed: /dev/parport/parport0/devices/Device ID probe .7.3.1.6.1 Directory with extra1
[  485.042962] sysctl table check failed: /dev/parport/parport0/devices/Device ID probe/timeslice .7.3.1.6.1.1 Missing strategy
[  485.083586] sysctl table check failed: /dev/parport/parport0/spintime .7.3.1.1 Missing strategy
[  485.083731] sysctl table check failed: /dev/parport/parport0/base-addr .7.3.1.2 Missing strategy
[  485.083878] sysctl table check failed: /dev/parport/parport0/irq .7.3.1.3 Missing strategy
[  485.084022] sysctl table check failed: /dev/parport/parport0/dma .7.3.1.4 Missing strategy
[  485.084166] sysctl table check failed: /dev/parport/parport0/modes .7.3.1.5 Missing strategy
[  485.084317] sysctl table check failed: /dev/parport/parport0/devices .7.3.1.6 Directory with extra1
[  485.084470] sysctl table check failed: /dev/parport/parport0/devices/active .7.3.1.6.-3 Missing strategy
[  485.084653] sysctl table check failed: /dev/parport/parport0/autoprobe .7.3.1.16 Missing strategy
[  485.084806] sysctl table check failed: /dev/parport/parport0/autoprobe0 .7.3.1.17 Missing strategy
[  485.084954] sysctl table check failed: /dev/parport/parport0/autoprobe1 .7.3.1.18 Missing strategy
[  485.085103] sysctl table check failed: /dev/parport/parport0/autoprobe2 .7.3.1.19 Missing strategy
[  485.085253] sysctl table check failed: /dev/parport/parport0/autoprobe3 .7.3.1.20 Missing strategy
[  485.114655] sysctl table check failed: /dev/parport/parport0/devices/lp .7.3.1.6.1 Directory with extra1
[  485.114856] sysctl table check failed: /dev/parport/parport0/devices/lp/timeslice .7.3.1.6.1.1 Missing strategy

....


Gabriel
