Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbXJYV63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbXJYV63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbXJYV6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:58:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33385 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbXJYV6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:58:22 -0400
Message-ID: <47211172.9070606@zytor.com>
Date: Thu, 25 Oct 2007 14:58:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "J.A. Magallon" <magallon@unizar.es>
CC: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: Opteron box and 4Gb memory
References: <20071025230904.03d5f46a@werewolf>
In-Reply-To: <20071025230904.03d5f46a@werewolf>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallon wrote:
> Hi...
> 
> I have some Quad-Opteron boxes with 4Gb memory and two of them are
> running two different Linux distros.
> 
> Box one sees 4Gb of memory, but box two just sees 3.
> Their mtrr setups are different:
> 
> Why ? Is it a bios setup problem ? A kernel problem ?
> grep HIGHMEN in configs for both kernels does not give anything, so
> I still understand less this thing...
> 

It would depend on how the BIOS programmed the memory controllers.  For 
32-bit (and lots of device) compatibility, a memory hole is required 
below 4 GB.  Not all memory controllers can remap memory in the 3-4 GB 
range above the 4 GB memory; I'm not sure if that varies with the 
different Opteron processors.

Also, if you run a 32-bit distribution, you need to have HIGHMEM_64G 
enabled in the kernel.

	-hpa
