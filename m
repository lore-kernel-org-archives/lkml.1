Return-Path: <linux-kernel-owner+w=401wt.eu-S1760879AbXFDXSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760879AbXFDXSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 19:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757177AbXFDXSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 19:18:09 -0400
Received: from animx.eu.org ([216.98.75.249]:60630 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756967AbXFDXSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 19:18:09 -0400
X-Greylist: delayed 2945 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jun 2007 19:18:08 EDT
Date: Mon, 4 Jun 2007 18:28:40 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: Tom Moore <tmoore@spatial.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 4Gb ram not showing up
Message-ID: <20070604222840.GC10208@animx.eu.org>
Mail-Followup-To: Tom Moore <tmoore@spatial.ca>,
	linux-kernel@vger.kernel.org
References: <46642C60.209@spatial.ca> <20070604191052.GD10008@csclub.uwaterloo.ca> <46646BF2.9020705@spatial.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46646BF2.9020705@spatial.ca>
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Moore wrote:
> Thank you for the reply back.  Your answer makes perfect sense to me, 
> and it is what I had suspected but was not sure about.  The math seems 
> to indicate that 4Gb of ram plus 1Gb of PCI address space equals 5Gb of 
> memory space.  So it does sound like I should have a larger kernel model.
> 
> What confused me the most (and still does), is the help message string 
> that is presented for the CONFIG_HIGHMEM4G option:
>  "Select this if you have a 32-bit processor and between 1 and 4 
> gigabytes of physical RAM."

4 is not between 1 and 4.

> Well that sounds like the amount of memory that I have, so that is what 
> I selected.

You should select CONFIG_HIGHMEM64G.

> Also, although I know what PAE stands for, I don't know how to select it 
> when building a kernel.  Would I get this from the CONFIG_HIGHMEM64G 
> option?  The help text for that says:
>  "Select this if you have a 32-bit processor and more than 4 gigabytes 
> of physical RAM."

Personally, I feel the wording should say:
Select this if you have a 32-bit processor and 4 or more gigabytes of
physical RAM.

It may not hurt to say 3 or more, but I'm not that familiar with x86
hardware in regards to memory.

> This does not sound like it applies to my hardware.  There is something 
> wrong with my understanding, or with these message strings.  I am still 
> confused.

It does.

Here's my system (4gb of memory):
             total       used       free     shared    buffers     cached
Mem:       3619996    3289352     330644          0     469764    2025416
-/+ buffers/cache:     794172    2825824
Swap:            0          0          0

I know it says 3.6gb of memory, but 4gb is installed.  I had 5gb in this
machine and I saw all 5gb.  This is a 32-bit dual xeon (12gb max memory)

I would be interested to know where the last 400mb of memory went.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
