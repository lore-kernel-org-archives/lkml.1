Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbXLTTuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbXLTTuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 14:50:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbXLTTty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 14:49:54 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:47187 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbXLTTty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 14:49:54 -0500
Date: Thu, 20 Dec 2007 22:50:21 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Tony Camuso <tcamuso@redhat.com>, Loic Prylli <loic@myri.com>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
Message-ID: <20071220195021.GA427@jurassic.park.msu.ru>
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com> <20071220181603.GF29690@parisc-linux.org> <476AB920.7040604@myri.com> <476ABCBF.8090006@redhat.com> <20071220190833.GH29690@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220190833.GH29690@parisc-linux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 12:08:33PM -0700, Matthew Wilcox wrote:
> On Thu, Dec 20, 2007 at 02:04:31PM -0500, Tony Camuso wrote:
> > Does anybody see a down side to this?
> 
> It'll be slower than it would be if we used mmconfig directly.  Now yes,
> nobody should be using pci config space in performance critical paths
> ... but see the tg3 driver.

Use type 1 just for the first 64 bytes and tg3 will be happy. All we need
is to avoid touching BARs with mmconfig.

Ivan.
