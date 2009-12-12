Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbZLLHAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbZLLHAe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 02:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbZLLHAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 02:00:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42132
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507AbZLLHAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 02:00:32 -0500
Date: Fri, 11 Dec 2009 23:00:38 -0800 (PST)
Message-Id: <20091211.230038.179945578.davem@davemloft.net>
To: mingo@elte.hu
Cc: gregkh@suse.de, stern@rowland.harvard.edu, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [build failure] Re: [GIT PATCH] USB patches for 2.6.33-git
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091212065923.GA8500@elte.hu>
References: <20091211212646.GB6624@kroah.com>
	<20091212065923.GA8500@elte.hu>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 12 Dec 2009 07:59:23 +0100

> 
> FYI, there's a new build breakage on latest upstream, on allyesconfig 
> x86:
> 
>  drivers/net/usb/kaweth.c: In function kaweth_open:
>  drivers/net/usb/kaweth.c:719: error: implicit declaration of function usb_autopm_enable
> 
> The problem appears to be that usb_autopm_enable() is obsolete and got 
> eliminated recently via:

I posted about this a few hours ago, it's been resolved and a fix
is in net-2.6 and will be pushed out soon.
