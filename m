Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbZF3DIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbZF3DIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 23:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZF3DIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 23:08:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:57499 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbZF3DIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 23:08:06 -0400
Message-ID: <4A49815C.1080603@kernel.org>
Date: Tue, 30 Jun 2009 12:07:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: David Miller <davem@davemloft.net>, hancockr@shaw.ca,
       alan@lxorguk.ukuu.org.uk, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, daniel.ritz@gmx.ch,
       linux@dominikbrodowski.net, kaneshige.kenji@jp.fujitsu.com,
       towerlexa@gmx.de, benh@kernel.crashing.org, mingo@elte.hu,
       tglx@linutronix.de, tony.luck@intel.com
Subject: Re: [RFC PATCH 1/2] pci: determine CLS more intelligently
References: <4A43234D.9050608@kernel.org> <20090625.020507.203808859.davem@davemloft.net> <20090625173355.GA4847@kroah.com>
In-Reply-To: <20090625173355.GA4847@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Jun 2009 03:07:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Jun 25, 2009 at 02:05:07AM -0700, David Miller wrote:
>> From: Tejun Heo <tj@kernel.org>
>> Date: Thu, 25 Jun 2009 16:12:13 +0900
>>
>>> sparc64 is currently the only one using PCI_CACHE_LINE_BYTES.
>> Feel free to add the patch below and:
>>
>> Acked-by: David S. Miller <davem@davemloft.net>
>>
>> Although I think it's better to declare pci_dfl_cache_line_size in
>> linux/pci.h instead of making every arch do the extern decl.
> 
> I agree, that would make more sense.
> 
> Otherwise it looks good to me:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Great, I'll incorporate both comments and repost the patchset after
Benjamin's testing or before the end of this week.

Thanks.

-- 
tejun
