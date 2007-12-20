Return-Path: <linux-kernel-owner+w=401wt.eu-S1760775AbXLTU13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775AbXLTU13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbXLTU1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:27:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637AbXLTU1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:27:20 -0500
Message-ID: <476AD01B.3070308@redhat.com>
Date: Thu, 20 Dec 2007 15:27:07 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Matthew Wilcox <matthew@wil.cx>, Loic Prylli <loic@myri.com>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com> <20071220181603.GF29690@parisc-linux.org> <476AB920.7040604@myri.com> <476ABCBF.8090006@redhat.com> <20071220190833.GH29690@parisc-linux.org> <20071220195021.GA427@jurassic.park.msu.ru>
In-Reply-To: <20071220195021.GA427@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:

> Use type 1 just for the first 64 bytes and tg3 will be happy. All we need
> is to avoid touching BARs with mmconfig.
> 
> Ivan.

Re-thinking this ...

The problem I see with this approach is that it does not help devices
that are mmconfig-unfriendly and will not work above the 64-byte offset.

So you will be able to configure the BARS of such a device, but not be
able to do much of anything else.

