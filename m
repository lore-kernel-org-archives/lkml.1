Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbXHOMAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbXHOMAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 08:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbXHOMA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 08:00:27 -0400
Received: from ozlabs.org ([203.10.76.45]:58449 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbXHOMA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 08:00:26 -0400
From: Michael Neuling <mikey@neuling.org>
To: balbir@linux.vnet.ibm.com
cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] Documentation: fix getdelays.c example -l option and segv 
In-reply-to: <46C2E189.7040504@linux.vnet.ibm.com> 
References: <18240.1186734285@neuling.org> <46C2A505.7040008@linux.vnet.ibm.com> <11201.1187165591@neuling.org> <46C2E189.7040504@linux.vnet.ibm.com>
Comments: In-reply-to Balbir Singh <balbir@linux.vnet.ibm.com>
   message dated "Wed, 15 Aug 2007 16:50:41 +0530."
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 21.4.1
Date: Wed, 15 Aug 2007 22:00:21 +1000
Message-ID: <26889.1187179221@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Interesting, we never used -l that way. We used -l to get data for all
> exiting tasks
> 
> ./getdelays -d -l
> 
> For the usage you've mentioned, I'd use
> 
> while :
> do
> 	sleep 2
> 	./getdelays -p 1 -d
> done
> 
> I guess your changes change getdelays and since there are other ways
> to obtaining the same data, I'd remove the last bit of changes made
> to send the TGID often to get data.

Ok.  I'll resubmit with just the first fix.

Mikey
