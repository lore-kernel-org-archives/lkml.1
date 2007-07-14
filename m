Return-Path: <linux-kernel-owner+w=401wt.eu-S1763814AbXGNAst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763814AbXGNAst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 20:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758459AbXGNAsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 20:48:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60589 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759264AbXGNAsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 20:48:40 -0400
Message-ID: <46981C73.8060402@zytor.com>
Date: Fri, 13 Jul 2007 17:44:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Greg KH <greg@kroah.com>, Bryan Wu <bryan.wu@analog.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org,
       Nish Aravamudan <nish.aravamudan@gmail.com>
Subject: Re: Linux 2.6.22.1
References: <29495f1d0707121135u2a07cf04nb8bfe555c5c63679@mail.gmail.com> <1184307380.8943.7.camel@roc-desktop> <20070713061617.GA24317@kroah.com> <20070713064751.GA3492@stusta.de>
In-Reply-To: <20070713064751.GA3492@stusta.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> 
> I found the problem and (ab)used my kstable group rights to fix it:
> 
> objects/info/alternates of linux-2.6.22.y.git contained
>   /home/ftp/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/objects
> instead of
>   /pub/scm/linux/kernel/git/torvalds/linux-2.6.git/objects
> 
> This seems to exist on git.kernel.org but not on www.kernel.org, 
> explaining why the http method didn't work.
> 

No, it's because the /home/ftp/pub/... path isn't visible to the http
namespace.

	-hpa
