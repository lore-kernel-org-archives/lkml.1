Return-Path: <linux-kernel-owner+w=401wt.eu-S1760427AbZBERcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760427AbZBERcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760212AbZBERcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:32:25 -0500
Received: from ns.suse.de ([195.135.220.2]:47341 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324AbZBERcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:32:23 -0500
Message-ID: <498B2294.5010809@suse.de>
Date: Thu, 05 Feb 2009 18:32:04 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com, fenghua.yu@intel.com,
       akpm@linux-foundation.org, frank@f-seidel.de,
       Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] PCI: add missing KERN_* constants to printks
References: <498B2116.6010707@suse.de> <20090205172859.GA20558@kroah.com>
In-Reply-To: <20090205172859.GA20558@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Feb 05, 2009 at 06:25:42PM +0100, Frank Seidel wrote:
>> - 	dbg("pcie_port_service_register = %d\n", retval);
>> +	dbg(KERN_DEBUG "pcie_port_service_register = %d\n", retval);
> 
> dbg() already sets the KERN_ level, right?

No, its definition in pciehp.h is:
#define dbg(format, arg...)                                             \
        do {                                                            \
                if (pciehp_debug)                                       \
                        printk("%s: " format, MY_NAME , ## arg);        \
        } while (0)
