Return-Path: <linux-kernel-owner+w=401wt.eu-S1759733AbYA1VPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733AbYA1VPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 16:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbYA1VP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 16:15:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbYA1VP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 16:15:27 -0500
Message-ID: <479E455F.7010706@redhat.com>
Date: Mon, 28 Jan 2008 16:13:03 -0500
From: Peter Jones <pjones@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071209)
MIME-Version: 1.0
To: Konrad Rzeszutek <konrad@darnok.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Doug Maxey <dwm@enoyolf.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       greg@kroah.com, darnok@68k.org, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, lenb@kernel.org,
       mike.anderson@us.ibm.com, dwm@austin.ibm.com, arjan@infradead.org,
       michaelc@cs.wisc.edu, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] Add iSCSI iBFT support (v0.4.5)
References: <20080125220629.GA25325@andromeda.dapyr.net> <22101.1201547493@bebe.enoyolf.org> <479E2E89.7030704@zytor.com> <200801281547.00865.konrad@darnok.org>
In-Reply-To: <200801281547.00865.konrad@darnok.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek wrote:
>> iBFT is not platform-independent; it only makes sense on platforms with
>> ACPI (and even then, just barely; ACPI is a poor fit for it and it was
>> probably "integrated" with ACPI for political reasons.)
> 
> The spec just mentions that iBFT table has to be "compatible with an ACPI 
> table format" and nothing else.

Well, that's not quite accurate.  It also mentions that OEM IDs for 
vendors come from the ACPI SIG, and they also reserved the "IBFT" 
signature with the ACPI SIG (it's in ACPI 3.0).  It's also pretty clear 
that the "Locating the iBFT" section in the spec used to be a list with 
more than one entry and has been edited down to one.

That being said, I don't think there's any reason to expect the table to 
show up on anything but i386 and x86_64, and maybe ia64.

-- 
   Peter
