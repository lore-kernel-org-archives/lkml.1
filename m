Return-Path: <linux-kernel-owner+w=401wt.eu-S1760974AbZJNVeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760974AbZJNVeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 17:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760305AbZJNVe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 17:34:29 -0400
Received: from khc.piap.pl ([195.187.100.11]:33596 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756549AbZJNVe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 17:34:29 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: ddutile@redhat.com
Cc: Stefan Assmann <sassmann@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, kaneshige.kenji@jp.fujitsu.com,
       matthew@wil.cx
Subject: Re: GT/s vs Gbps for PCIe bus speed
References: <4AD58EEE.4070405@redhat.com>
	<m3ljjdstbb.fsf@intrepid.localdomain> <4AD62B52.9060200@redhat.com>
Date: Wed, 14 Oct 2009 23:33:50 +0200
In-Reply-To: <4AD62B52.9060200@redhat.com> (Don Dutile's message of "Wed, 14
	Oct 2009 15:49:38 -0400")
Message-ID: <m33a5lsls1.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Dutile <ddutile@redhat.com> writes:

> so, maybe the right terms are
>  2.5 GHz PCI-E
>  5.0 GHz PCI-E

I don't thinks so. It would be fine for PCI/PCI-X, as there is a clock
signal with a given frequency. PCI-E doesn't use a clock signal. Really,
the meaningful value is a cycle time (or number of cycles per second).

Of course one could calculate or measure a frequency (or spectrum) for
a given code sequence on PCI-E. For example, for something like
01010101010101 (raw code) the (base) frequency would be 1.25 or 2.5 GHz
for 2.0. For other patterns it would be lower.

> No matter how many lanes, or how the data is sent (long or short bursts),
> the frequency rate is a constant.

Actually, this is not the case.

> So, the data rate is not stated, just the cycle rate.

Cycle rate, sure. Frequency, no.

> This would follow the PCIX syntax as well, which is
> void of bandwidth illusions.

Bandwidth, actually it may make some sense. But it would have to take
#lanes into account, I'm not sure we want to do it. And it would create
another confusion - raw vs effective bandwidth (like 125 vs 100 Mbps
with Ethernet).
-- 
Krzysztof Halasa
