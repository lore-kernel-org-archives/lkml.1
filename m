Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbZBERu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbZBERu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbZBERuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:50:46 -0500
Received: from kroah.org ([198.145.64.141]:36628 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751513AbZBERup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:50:45 -0500
Date: Thu, 5 Feb 2009 09:49:59 -0800
From: Greg KH <greg@kroah.com>
To: Frank Seidel <frank@f-seidel.de>
Cc: Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com, fenghua.yu@intel.com,
       akpm@linux-foundation.org, Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] PCI: add missing KERN_* constants to printks
Message-ID: <20090205174959.GA29368@kroah.com>
References: <498B2116.6010707@suse.de> <20090205172859.GA20558@kroah.com> <498B2294.5010809@suse.de> <498B23A5.6090006@f-seidel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B23A5.6090006@f-seidel.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 06:36:37PM +0100, Frank Seidel wrote:
> Frank Seidel wrote:
> > No, its definition in pciehp.h is:
> > ...
> 
> P.S.: I also thought about changing it directly inside
> the macro. Would you prefer that?
> I decided against that because those printk-macros often
> still use the loglevel prefix and i didn't want to change
> semantics of the macro (eventhough one would of course
> suspect it to set KERN_DEBUG).

I think that any macro called "dbg" should set the level automatically,
as that is the way that the other macros in the kernel with this name do
things...

thanks,

greg k-h
