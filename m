Return-Path: <linux-kernel-owner+w=401wt.eu-S1761090AbXLTVAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761090AbXLTVAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbXLTVAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:00:46 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:46399 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbXLTVAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:00:45 -0500
Date: Thu, 20 Dec 2007 14:00:44 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Loic Prylli <loic@myri.com>
Cc: Tony Camuso <tcamuso@redhat.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
Message-ID: <20071220210044.GK29690@parisc-linux.org>
References: <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com> <20071220181603.GF29690@parisc-linux.org> <476AB920.7040604@myri.com> <476ABCBF.8090006@redhat.com> <20071220190833.GH29690@parisc-linux.org> <476ACB20.6030803@myri.com> <20071220201529.GJ29690@parisc-linux.org> <476AD6FD.3060700@myri.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476AD6FD.3060700@myri.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 03:56:29PM -0500, Loic Prylli wrote:
> I know the final device is not aware on how the config request was
> originated. I am just saying platforms built around the Intel 82801
> chipset (ICH2) don't support mmconfig at all. I would also not be
> surprised if the platforms where tg3 needs TG3_FLAG_PCIX_TARGET_HWBUG
> might also not support mmconfig (but for this second case, it's only
> speculation based on seeing a couple posts about
> TG3_FLAG_PCIX_TARGET_HWBUG where amd hypertransport/PCI-X chipsets where
> mentioned). If you know of a platform that support mmconfig, and where
> the tg3 does need to use relatively intensively pci-conf-space, I'll be
> happy to be corrected.

tg3 is available as an add-in pci card.  i have one.  i can plug it into
a machine that does support mmconfig.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
