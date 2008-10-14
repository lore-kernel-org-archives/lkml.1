Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760AbYJNUYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbYJNUYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbYJNUYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:24:05 -0400
Received: from xenotime.net ([66.160.160.81]:36970 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752953AbYJNUYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:24:04 -0400
Date: Tue, 14 Oct 2008 13:23:53 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Dimitri Sivanich <sivanich@sgi.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] export clockevents_register_device
In-Reply-To: <20081014163814.GA1693@sgi.com>
Message-ID: <Pine.LNX.4.64.0810141323050.20761@shark.he.net>
References: <20081014163814.GA1693@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008, Dimitri Sivanich wrote:

> Export the clockevents_register_device().

Needs justification, always....

> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> 
> Index: linux/kernel/time/clockevents.c
> ===================================================================
> --- linux.orig/kernel/time/clockevents.c	2008-10-14 11:31:17.000000000 -0500
> +++ linux/kernel/time/clockevents.c	2008-10-14 11:31:40.000000000 -0500
> @@ -173,6 +173,7 @@ void clockevents_register_device(struct 
>  
>  	spin_unlock(&clockevents_lock);
>  }
> +EXPORT_SYMBOL_GPL(clockevents_register_device);
>  
>  /*
>   * Noop handler when we shut down an event device
> --

-- 
~Randy
