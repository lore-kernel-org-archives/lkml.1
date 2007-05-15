Return-Path: <linux-kernel-owner+w=401wt.eu-S1760854AbXEOQjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbXEOQjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 12:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757022AbXEOQjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 12:39:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54980 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756672AbXEOQjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 12:39:16 -0400
Date: Tue, 15 May 2007 17:42:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vasily Averin <vvs@sw.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: [patch i2o 1/6] i2o_cfg_passthru cleanup
Message-ID: <20070515174251.2e49ae71@the-village.bc.nu>
In-Reply-To: <4649AAB2.20801@sw.ru>
References: <4649AA6C.2080808@sw.ru>
	<4649AAB2.20801@sw.ru>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -      cleanup:
> +cleanup:
>  	kfree(reply);
> +	if (msg)
> +out:
> +		i2o_msg_nop(c, msg);

Put the label before the if. Much saner that way


>  	kfree(reply);
> +	if (msg)
> +out:
> +		i2o_msg_nop(c, msg);
>  	return rcode;

Ditto
