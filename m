Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYIIQFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYIIQFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbYIIQFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:05:10 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:50630 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbYIIQFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:05:09 -0400
X-IronPort-AV: E=Sophos;i="4.32,366,1217808000"; 
   d="scan'208";a="1742281"
User-Agent: Microsoft-Entourage/11.4.0.080122
Date: Tue, 09 Sep 2008 17:05:00 +0100
Subject: Re: [Xen-devel] Re: [PATCH 1 of 7] x86: add _PAGE_IOMAP pte flag
 for IO mappings
From: Keir Fraser <keir.fraser@eu.citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>,
       Xen Devel <xen-devel@lists.xensource.com>,
       Andi Kleen <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <C4EC5D3C.26EF1%keir.fraser@eu.citrix.com>
Thread-Topic: [Xen-devel] Re: [PATCH 1 of 7] x86: add _PAGE_IOMAP pte flag
 for IO mappings
Thread-Index: AckSlc+mDfS05H6JEd2WrgAX8io7RQ==
In-Reply-To: <48C69AB6.20500@goop.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 09 Sep 2008 16:05:07.0033 (UTC) FILETIME=[D3D7C490:01C91295]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/9/08 16:48, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

> Keir Fraser wrote:
>> That's basically what our _PAGE_IO flag (in our old Linux patchset) means.
>> We use it to cause pte_pfn() to return an invalid pfn and hence avoid
>> reference counting that way. Since kernel mappings are never reference
>> counted (I think?) perhaps we could use _PAGE_SPECIAL even if it is
>> restricted to use on user mappings.
> 
> Well, _PAGE_IOMAP's most important semantic from Xen's perspective is
> that the frame number is considered to already be an MFN and so isn't
> converted.  It may be that _PAGE_SPECIAL is also useful for its "no
> refcount" properties, but we could set both in that case.

Oh, yes, our _PAGE_IO has the same meaning.

 -- Keir


