Return-Path: <linux-kernel-owner+w=401wt.eu-S1760518AbYE2Uay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760518AbYE2Uay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 16:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759449AbYE2UaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 16:30:07 -0400
Received: from mga07.intel.com ([143.182.124.22]:32473 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753757AbYE2UaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 16:30:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,562,1204531200"; 
   d="scan'208";a="254247041"
Message-ID: <483F1232.4010003@linux.intel.com>
Date: Thu, 29 May 2008 13:29:38 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: David Woodhouse <dwmw2@infradead.org>,
       James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of	the
 kernel.
References: <1211995212.3445.52.camel@localhost.localdomain>	<20080528.225826.40264516.davem@davemloft.net>	<1212041839.8888.38.camel@pasglop> <20080529124548.GC8065@mit.edu>	<1212077700.26088.83.camel@shinybook.infradead.org> <20080529164745.GA21763@kroah.com>
In-Reply-To: <20080529164745.GA21763@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> And at that point I'd like to remove them completely, to a separate git
>> tree and tarball. Those who really want to build them in to their static
>> kernel would still be able to, but it wouldn't be the default behaviour.
> 
> This I disagree with.  Leaving it in a single directory makes it easier
> for some distros to patch it away to apease their feelings about the
> issue.  But for some of use, we like the firmware in our kernels, it
> makes it easier to boot for one, and we don't have to deal with
> different firmware packages.  So I say leave them in, with the option to
> get them elsewhere, like you are doing.
> 

I very much would like to see a kernel-firmware or something tarbal that contains
a copy of all relevant "freely distributable" firmware, that users can just install
independent of the actual kernel version (and that kbuild would just pick up somehow).
That way we can deal with a lot more firmware without having to pollute the kernel / kernel release process
(after all, the timing is different in terms of releasing) while making it easy
to get the lot of it.

Now.. of course what "freely distributable" means is a huge debate. I don't care ;)
