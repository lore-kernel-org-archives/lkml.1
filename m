Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbZJOHlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbZJOHlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 03:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934760AbZJOHlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 03:41:24 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:22189 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934112AbZJOHlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 03:41:23 -0400
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAOtu1kqrR7Hu/2dsb2JhbADAXZhthDAE
X-IronPort-AV: E=Sophos;i="4.44,565,1249257600"; 
   d="scan'208";a="214687999"
From: Roland Dreier <rdreier@cisco.com>
To: ddutile@redhat.com
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Stefan Assmann <sassmann@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, kaneshige.kenji@jp.fujitsu.com,
       matthew@wil.cx
Subject: Re: GT/s vs Gbps for PCIe bus speed
References: <4AD58EEE.4070405@redhat.com>
	<m3ljjdstbb.fsf@intrepid.localdomain> <4AD62B52.9060200@redhat.com>
	<m33a5lsls1.fsf@intrepid.localdomain> <4AD655E1.7080005@redhat.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 15 Oct 2009 00:40:46 -0700
In-Reply-To: <4AD655E1.7080005@redhat.com> (Don Dutile's message of "Wed, 14
	Oct 2009 18:51:13 -0400")
Message-ID: <adabpk985q9.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Oct 2009 07:40:47.0122 (UTC) FILETIME=[CF2D8720:01CA4D6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Yeah, the std nomenclature is PCI-e not PCI-E.

To be pedantic: "PCIe" without the hyphen is correct, cf
http://www.pcisig.com/specifications/pciexpress/ (the web page, not any
member-only specs) -- "PCIe" is used many times there.

 > Again, trying to generate output that relates
 > to what devices are spec to run at: 2.5GHz or 5.0GHz links.

But the spec does not talk about rates in GHz but rather GT/s (since
PCIe is not clocked but rather uses a recovered embedded clock).
Matching the terminology of the PCIe spec by using GT/s really seems
best in terms of clarity, and describes the situation most exactly,
since by using GT/s one also sidesteps the issue of having the data rate
depend on the link width.

 - R.
