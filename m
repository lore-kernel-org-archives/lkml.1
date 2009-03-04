Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbZCDN3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbZCDN3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 08:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbZCDN3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 08:29:32 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36737 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750972AbZCDN3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 08:29:31 -0500
Date: Wed, 4 Mar 2009 13:29:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, pgnet.trash@gmail.com
Subject: Re: [PATCH 2.6.29-rc7 2/2] x86: disallow DAC for MCP51 PCI bridge
Message-ID: <20090304132945.2b242e63@lxorguk.ukuu.org.uk>
In-Reply-To: <49AE53B5.6000009@kernel.org>
References: <49ADE82D.40103@kernel.org>
	<49ADE9D3.6080000@kernel.org>
	<20090304095727.707ac18c@lxorguk.ukuu.org.uk>
	<49AE53B5.6000009@kernel.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Organization: None.. I'm free I'm free bwhahahahaha!
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> x86 is blacklisting DAC for everything VIA. :-)

I'd assume that comes from published docs given VIA actually publish
stuff if you ask nicely.
> 
> * MCP51 is a very old chipset at this point (it's circa 2005).  Not
>   many machine would be running with >4GB memory to begin with.
> 
> * Given the above and scarcity of DAC on most end user machines
>   (nothing on MCP51 does DAC by default), lack of reports isn't too
>   surprising.
> 
> * The board doesn't have a 64bit connector.  It can't be dodgy
>   connector and sil24 is known to behave well with DAC.  The failure
>   being specific to the particular machine doesn't seem likely.
> 
> I'll ping nvidia about it but I think your bar is too high.

I don't think wanting to see *two* examples is a high bar.
