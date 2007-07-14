Return-Path: <linux-kernel-owner+w=401wt.eu-S1763416AbXGNASc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763416AbXGNASc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 20:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbXGNASY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 20:18:24 -0400
Received: from userbg049.dsl.pipex.com ([62.190.246.49]:4208 "EHLO
	homer.intra.qzxyz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752498AbXGNASX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 20:18:23 -0400
Message-ID: <4698164C.3080302@talk21.com>
Date: Sat, 14 Jul 2007 01:18:20 +0100
From: Scott Ashcroft <scott.ashcroft@talk21.com>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Always zero test in arch/i386/pci/mmconfig-shared.c
References: <fa.nwpKC6+7UvIqGGeRe+rNP7ZO5P4@ifi.uio.no> <46980DE4.6090404@shaw.ca>
In-Reply-To: <46980DE4.6090404@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
  > You missed this code:
> 
> name = pci_mmcfg_probes[i].probe();
> 
> This calls one of the probe functions above, which will set 
> pci_mmcfg_config_num to something else, as with the name variable. It 
> may set the name but not the config num, if the chipset is recognized 
> but MMCONFIG isn't enabled, etc.

Obvious now you've pointed it out. Bit of of a weird way to do things.
I might brew up a patch which adds the names to the 
pci_mmcfg_hostbridge_probe struct, since they appear to be always 
returned if the probe function is called, and make the probe functions 
return the config num.

Cheers,
Scott
