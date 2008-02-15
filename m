Return-Path: <linux-kernel-owner+w=401wt.eu-S1760889AbYBOShy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760889AbYBOShy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759734AbYBOShk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:37:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:3639 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760300AbYBOShj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:37:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,359,1199692800"; 
   d="scan'208";a="258109756"
Message-ID: <47B5DB95.3020002@intel.com>
Date: Fri, 15 Feb 2008 10:36:05 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-mm1 bugs
References: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu> <47B5BDC0.3020003@intel.com> <E1JQ3cu-0005ZW-7k@pomaz-ex.szeredi.hu> <47B5C38A.5000909@intel.com> <E1JQ4ik-0005iq-NH@pomaz-ex.szeredi.hu> <47B5D6EB.5010203@intel.com> <E1JQ5Er-0005p7-HD@pomaz-ex.szeredi.hu>
In-Reply-To: <E1JQ5Er-0005p7-HD@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Feb 2008 18:36:56.0055 (UTC) FILETIME=[BDBBF870:01C87001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>> the register dump looks OK as far as I can see. Since initialization
>> works OK and the adapter seems to be setup OK reading from the
>> register dump, I'm not sure at all what is going on.
>>
>> can you try manually ifup-ing the device and running tcpdump? do you
>> see packets coming in?
> 
> Well it does seem to receive the DHCP reply.
> 
>> just for kicks, have you tried a different cable? or is the adapter
>> consistently working properly using a different kernel/driver?
> 
> It has been consistently working properly for a long time with various
> kernels (and the e1000 driver).  I've now swithed to 2.6.24-mm1 and
> e1000e, and it's almost consistently broken after boot and resume, and
> sometimes needs several tries (with the KDE NetworkManager thingy) to
> make it work.

maybe it's worth trying linux-2.6.git instead for now? The e1000e driver is
actually involved in the dhcp handshake so we can't just rule a bug out yet.
However, with my own t60 things appear to work just fine.

how does manually getting a dhcp address go? can you eliminate networkmanager
perhaps? just kill & restart dhclient over and over again...

Auke


