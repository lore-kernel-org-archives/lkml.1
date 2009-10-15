Return-Path: <linux-kernel-owner+w=401wt.eu-S1751552AbZJOOGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbZJOOGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 10:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbZJOOGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 10:06:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbZJOOGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 10:06:05 -0400
Message-ID: <4AD72C27.60006@redhat.com>
Date: Thu, 15 Oct 2009 10:05:27 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081113)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Stefan Assmann <sassmann@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, kaneshige.kenji@jp.fujitsu.com,
       matthew@wil.cx
Subject: Re: GT/s vs Gbps for PCIe bus speed
References: <4AD58EEE.4070405@redhat.com>	<m3ljjdstbb.fsf@intrepid.localdomain> <4AD62B52.9060200@redhat.com>	<m33a5lsls1.fsf@intrepid.localdomain> <4AD655E1.7080005@redhat.com> <adabpk985q9.fsf@cisco.com>
In-Reply-To: <adabpk985q9.fsf@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > Yeah, the std nomenclature is PCI-e not PCI-E.
> 
> To be pedantic: "PCIe" without the hyphen is correct, cf
> http://www.pcisig.com/specifications/pciexpress/ (the web page, not any
> member-only specs) -- "PCIe" is used many times there.
> 
agreed.

>  > Again, trying to generate output that relates
>  > to what devices are spec to run at: 2.5GHz or 5.0GHz links.
> 
> But the spec does not talk about rates in GHz but rather GT/s (since
> PCIe is not clocked but rather uses a recovered embedded clock).
Yes, it does in section 2.1, page 38 of base spec:
   Signaling rate – Once initialized, each Link must only operate at one of the supported signaling
   levels. For the first generation of PCI Express technology, there is only one signaling rate
   defined, which provides an effective 2.5 Gigabits/second/Lane/direction of raw bandwidth.
   The second generation provides an effective 5.0 Gigabits/second/Lane/direction of raw
   bandwidth. The data rate is expected to increase with technology advances in the future.

Additionally, the original specs listed the Link speeds in the Link Capabilities
register as Gb/s; this is also reflected in MindShare's PCI Express System Architecture
book (3rd edition; I'm curious to find out if the 4th edition updated this area
to the GT/s terminology).

> Matching the terminology of the PCIe spec by using GT/s really seems
> best in terms of clarity, and describes the situation most exactly,
> since by using GT/s one also sidesteps the issue of having the data rate
> depend on the link width.
> 
>  - R.

So, the original spec (and for those that worked on it originally), the
link speeds were stated in Gb/s.
If GT/s will be the nomenclature used by PCIe vendors
when they have varying speed devices, then I agree, use the GT/s terminology.
Doing a number of varying web searches, it appears the hw vendors
are avoiding which to use: T/s or b/s by using "2.5G" & "5.0G"
sometimes prefixing with "Gen1-" & "Gen2-" respectively.

Maybe we should take a hint from the hw folks and drop the use of "T/s" or "b/s"
and just output "2.5G", "5.0G".... and when it gets here "8.0G".

cheers... Don

