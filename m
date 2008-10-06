Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbYJFRRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbYJFRRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 13:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbYJFRRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 13:17:47 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:56258 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbYJFRRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:17:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lfqIvKN6aJn19GypdOnbZwMp36ugEBDe9UcQ3hZnhmXibu1sgEkydetJ9UFehGGewh
         lBhkrmljjL212YDy9a+BQrAuJXH5komGkmepbpLj9yV7O4UMnvtie3r3ruwcw51UagOW
         8L/DfVlS2cgagHzUbJNPd8Vm5qhmHgs7vY29M=
Date: Mon, 6 Oct 2008 21:17:42 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrey Batyiev <batyiev@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: APIC misconfiguration
Message-ID: <20081006171742.GB7317@localhost>
References: <200810061923.09076.batyiev@gmail.com> <20081006165007.GA7317@localhost> <200810061955.28915.batyiev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810061955.28915.batyiev@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andrey Batyiev - Mon, Oct 06, 2008 at 07:55:28PM +0300]
| Hi Cyrill,
| 
| > actually it's not a bug of APIC itself but rather misconfigured
| > device I think. Not sure thru which bus it does work (pci
| > i suppose) but I think you better are to fix it on more higher
| > level like in config space of this device. PCI guys could tell
| > you more about this area I believe.
| 
| Device is connected to ISA bus and haven't any autoconfiguration methods.
| 
| Thanks,
|    Andrey
| 

hmm... don't we have any ISA quirks already? If this device support
PnP there should be descriptor for irq line where you could change it
since I don't believe it would be a first device in kernel which behave
not as supposed and developers has to override some configs bits.
Hope it help (i didn't check ISA code though -- too busy now).

		- Cyrill -
