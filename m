Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbYA1TxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbYA1TxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYA1Twy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:52:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49351 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbYA1Twy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:52:54 -0500
Message-ID: <479E2E89.7030704@zytor.com>
Date: Mon, 28 Jan 2008 11:35:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Doug Maxey <dwm@enoyolf.org>
CC: Konrad Rzeszutek <konrad@darnok.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       greg@kroah.com, darnok@68k.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, lenb@kernel.org,
       mike.anderson@us.ibm.com, dwm@austin.ibm.com, arjan@infradead.org,
       michaelc@cs.wisc.edu, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] Add iSCSI iBFT support (v0.4.5)
References: <20080125220629.GA25325@andromeda.dapyr.net> <20080126220123.d20dd393.akpm@linux-foundation.org>  <200801281404.54155.konrad@darnok.org> <22101.1201547493@bebe.enoyolf.org>
In-Reply-To: <22101.1201547493@bebe.enoyolf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Maxey wrote:
> On Mon, 28 Jan 2008 14:04:51 EST, Konrad Rzeszutek wrote:
>>>> +EXPORT_SYMBOL(find_ibft);
>>> Is this x86-specific?  Are suitable Kconfig dependencies in place?
>> Originally I had it to be x86-specific but was told that I should make it all 
>> platforms since the IBFT is platform independent. Somebody can very well 
>> insert a NIC with IBFT on a IA64 machine or PPC.
> 
> I would beg to differ regarding the powerpc.  On powerpc, the bios is
> invisible and ignored.  We have our own "special" way, via the device-tree
> in procfs.
> 

iBFT is not platform-independent; it only makes sense on platforms with 
ACPI (and even then, just barely; ACPI is a poor fit for it and it was 
probably "integrated" with ACPI for political reasons.)

	-hpa
