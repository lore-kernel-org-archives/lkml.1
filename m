Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbZBQV0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbZBQV0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZBQVZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:25:53 -0500
Received: from mga06.intel.com ([134.134.136.21]:22154 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751118AbZBQVZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:25:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,225,1233561600"; 
   d="scan'208";a="387573825"
Message-ID: <499B2B5F.2070407@linux.intel.com>
Date: Tue, 17 Feb 2009 13:25:51 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/headers] x86: truncate ISA addresses to unsigned int
References: <tip-a7eb518998529c08cc53fef17756d9fe433b0c23@kernel.org> <1234905865.23466.11.camel@localhost.localdomain>
In-Reply-To: <1234905865.23466.11.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
>> +static inline unsigned int isa_virt_to_bus(volatile void *address)
> 
> The rest looks fine, but why is the address volatile?  The macro below
> never actually dereferences it.
> 

Because a volatile is permitted.  virt_to_phys() takes a volatile 
pointer for that reason.

	-hpa
