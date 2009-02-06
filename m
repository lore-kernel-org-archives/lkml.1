Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbZBFI6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbZBFI6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 03:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756867AbZBFI5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 03:57:48 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44123 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbZBFI5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 03:57:47 -0500
Message-ID: <498BFB82.5000605@jp.fujitsu.com>
Date: Fri, 06 Feb 2009 17:57:38 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Frank Seidel <fseidel@suse.de>
CC: linux kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, greg@kroah.com, kristen.c.accardi@intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com, fenghua.yu@intel.com,
       akpm@linux-foundation.org, frank@f-seidel.de,
       Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCHv2] PCI: add missing KERN_* constants to printks
References: <498B2116.6010707@suse.de> <498B29CC.2030000@suse.de> <498BEEF6.2040803@jp.fujitsu.com> <498BEFAD.8070102@suse.de>
In-Reply-To: <498BEFAD.8070102@suse.de>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Seidel wrote:
> Kenji Kaneshige wrote:
>> How about below. I think we can write printk in one line.
>>
>> #define dbg(format, arg...)						\
>> do {									\
>> 	if (pciehp_debug)						\
>> 		printk(KERN_DEBUG "%s: " format, MY_NAME, ## arg);	\
>> } while (0)
> 
> I wanted to keep the change as simple as possible and didn't wanna
> play with surrounding indentation. But yes, if thats preferred...
> i gonna change the patch to this. Shall i?
> 

I prefer it. I don't think it's so complex. And I can review and test
shpchp/pciehp part of your patch on my machine.

Thanks,
Kenji Kaneshige



