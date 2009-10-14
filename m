Return-Path: <linux-kernel-owner+w=401wt.eu-S1759218AbZJNWtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbZJNWtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbZJNWtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:49:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401AbZJNWtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:49:02 -0400
Message-ID: <4AD655E1.7080005@redhat.com>
Date: Wed, 14 Oct 2009 18:51:13 -0400
From: Don Dutile <ddutile@redhat.com>
Reply-To: ddutile@redhat.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081113)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Stefan Assmann <sassmann@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, kaneshige.kenji@jp.fujitsu.com,
       matthew@wil.cx
Subject: Re: GT/s vs Gbps for PCIe bus speed
References: <4AD58EEE.4070405@redhat.com>	<m3ljjdstbb.fsf@intrepid.localdomain> <4AD62B52.9060200@redhat.com> <m33a5lsls1.fsf@intrepid.localdomain>
In-Reply-To: <m33a5lsls1.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Don Dutile <ddutile@redhat.com> writes:
> 
>> so, maybe the right terms are
>>  2.5 GHz PCI-E
>>  5.0 GHz PCI-E
> 
Yeah, the std nomenclature is PCI-e not PCI-E.

> I don't thinks so. It would be fine for PCI/PCI-X, as there is a clock
> signal with a given frequency. PCI-E doesn't use a clock signal. Really,
> the meaningful value is a cycle time (or number of cycles per second).
> 
number of cycles/second == frequency.
cycle time = 1/frequency

>From a run-time perspective, the status is trying to
tell the user/admin what (steady-state) frequency the
links are running at : 2.5GHz or 5.0GHz.

> Of course one could calculate or measure a frequency (or spectrum) for
> a given code sequence on PCI-E. For example, for something like
> 01010101010101 (raw code) the (base) frequency would be 1.25 or 2.5 GHz
> for 2.0. For other patterns it would be lower.
> 
>> No matter how many lanes, or how the data is sent (long or short bursts),
>> the frequency rate is a constant.
> 
> Actually, this is not the case.
> 
Frequency changing would require link re-synch.
This code is dealing w/steady-state frequency.

>> So, the data rate is not stated, just the cycle rate.
> 
> Cycle rate, sure. Frequency, no.
> 
I think nomeclature is mixed up here.

>> This would follow the PCIX syntax as well, which is
>> void of bandwidth illusions.
> 
> Bandwidth, actually it may make some sense. But it would have to take
> #lanes into account, I'm not sure we want to do it. And it would create
> another confusion - raw vs effective bandwidth (like 125 vs 100 Mbps
> with Ethernet).

Again, trying to generate output that relates
to what devices are spec to run at: 2.5GHz or 5.0GHz links.

