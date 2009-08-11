Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbZHKOLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbZHKOLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZHKOLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:11:22 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:53578 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbZHKOLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:11:21 -0400
Date: Tue, 11 Aug 2009 10:43:02 +0200
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@gefanuc.com>
Cc: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
Message-ID: <20090811084302.GB3251@braap.org>
References: <20090803205657.964064732@mini.kroah.org> <20090803210111.GB28430@kroah.com> <20090808230145.GB27151@braap.org> <4A801644.2070009@gefanuc.com> <20090810141442.GA18456@braap.org> <20090810153127.GB23319@braap.org> <4A804D67.4080308@gefanuc.com> <20090810195048.GB3055@braap.org> <4A8125AC.30400@gefanuc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8125AC.30400@gefanuc.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martyn Welch wrote:
> Emilio G. Cota wrote:
>> Again, he (the driver writer) should know *nothing* about that.
>>
>> As for the scatter-gather case, what should happen is:
>>
>> User:		hey, there's a buffer I want to transfer. here's
>> 		a pointer and size
> Buffer where? On VME or PCI, where are you transferring it to? The API I  
> have will allow scattered locations on VME to be copied to PCI and  
> visa-versa, scattered locations on PCI to be copied to VME and  
> visa-versa. Even scattered locations on VME to scattered locations on  
> PCI with a bit of effort.

Admittedly our current tsi148 driver deals with the most common
situation: DMA from main (master) CPU RAM to/from a VME slave.

I'm not claiming we shouldn't support sg lists; however the
implementation should resemble the existing sg interfaces.
I'm currently working on something along those lines.

Thanks,
E.
