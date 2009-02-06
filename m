Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbZBFIHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbZBFIHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 03:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbZBFIHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 03:07:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:40119 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbZBFIHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 03:07:32 -0500
Message-ID: <498BEFAD.8070102@suse.de>
Date: Fri, 06 Feb 2009 09:07:09 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, greg@kroah.com, kristen.c.accardi@intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com, fenghua.yu@intel.com,
       akpm@linux-foundation.org, frank@f-seidel.de,
       Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCHv2] PCI: add missing KERN_* constants to printks
References: <498B2116.6010707@suse.de> <498B29CC.2030000@suse.de> <498BEEF6.2040803@jp.fujitsu.com>
In-Reply-To: <498BEEF6.2040803@jp.fujitsu.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kenji Kaneshige wrote:
> How about below. I think we can write printk in one line.
> 
> #define dbg(format, arg...)						\
> do {									\
> 	if (pciehp_debug)						\
> 		printk(KERN_DEBUG "%s: " format, MY_NAME, ## arg);	\
> } while (0)

I wanted to keep the change as simple as possible and didn't wanna
play with surrounding indentation. But yes, if thats preferred...
i gonna change the patch to this. Shall i?

Thanks,
Frank
