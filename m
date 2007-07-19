Return-Path: <linux-kernel-owner+w=401wt.eu-S1759152AbXGSUBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152AbXGSUBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbXGSUAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:00:51 -0400
Received: from mx1.suse.de ([195.135.220.2]:55662 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758314AbXGSUAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:00:49 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] [7/58] x86_64: various cleanups in NUMA scan node
Date: Thu, 19 Jul 2007 22:00:41 +0200
User-Agent: KMail/1.9.6
Cc: rientjes@google.com, patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200707191154.642492000@suse.de> <200707191921.22909.ak@suse.de> <86802c440707191038x7b37f949i6e1ff903ccc51b4f@mail.gmail.com>
In-Reply-To: <86802c440707191038x7b37f949i6e1ff903ccc51b4f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707192200.41369.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> "
>  * For initialized data:
>  * You should insert __initdata between the variable name and equal
>  * sign followed by value, e.g.:
>  *
>  * static int init_variable __initdata = 0;
>  * static char linux_logo[] __initdata = { 0x32, 0x36, ... };
> "
> 
> or we need to update these lines?

This might date back to old compilers that are now dropped (like 2.95) 

But recommending it this way is probably not bad, it's just not a catastrophe
to not follow the recommendation.

-Andi
