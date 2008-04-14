Return-Path: <linux-kernel-owner+w=401wt.eu-S1761935AbYDNU5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761935AbYDNU5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 16:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbYDNU4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 16:56:55 -0400
Received: from balanced.mail.policyd.dreamhost.com ([208.97.132.119]:56923
	"EHLO spunkymail-a9.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754378AbYDNU4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 16:56:54 -0400
X-Greylist: delayed 1318 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2008 16:56:54 EDT
Message-ID: <4803BF9D.4070304@dawes.za.net>
Date: Mon, 14 Apr 2008 22:33:33 +0200
From: Rogan Dawes <lists@dawes.za.net>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
Cc: chris@zankel.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] xtensa: don't offer PARPORT_PC
References: <20080414195551.GE26885@cs181133002.pp.htv.fi>
In-Reply-To: <20080414195551.GE26885@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:

>  config PARPORT_PC
>  	tristate "PC-style hardware"
>  	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV && \
> -		(!M68K || ISA) && !MN10300
> +		(!M68K || ISA) && !MN10300 && !XTENSA

Pardon a possibly stupid question here, but would it not make more sense 
to code the architectures for which these various devices *are* 
possible, rather than requiring each architecture to go through the 
entire config file and add their own "we don't do this" for many entries?

As seen, it is easy for them to be missed, hence all these recent patches.

The way I look at it, it is a lot easier to require that the arch 
maintainer adds specific entries to get their particular hardware 
working, rather than go through a working setup and figure out how much 
they can take away before it breaks.

Rogan
