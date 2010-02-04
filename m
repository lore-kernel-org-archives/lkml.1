Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab0BDTWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:22:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:5226 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078Ab0BDTWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:22:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,406,1262592000"; 
   d="scan'208";a="489724055"
Subject: Re: [PATCH] HPET: Drop WARN_ON for mismatch on HPET CMP readback
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100204191112.GA10135@basil.fritz.box>
References: <20100204191112.GA10135@basil.fritz.box>
Content-Type: text/plain
Date: Thu, 04 Feb 2010 11:22:15 -0800
Message-Id: <1265311335.16916.586.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 11:11 -0800, Andi Kleen wrote:
>  HPET: Drop WARN_ON for mismatch on HPET CMP readback
>     
>     At least one Intel chipset seems to always return a constant value
>     when reading back the HPET CMP register. This triggers the WARN_ON_ONCE
>     on each boot.

I don't know of chipset returning a constant value. Which chipset is
this one?
There is a chipset ICH9/10 errata where it returns a previous value,
instead of most recently written value. I had a patch for that here.

http://marc.info/?l=linux-kernel&m=125849385330302&w=2

I wanted to send out final patch with a pointer to ICH9/10 spec update
which describes the errata. But, look like that spec update hasn't
happened yet. As we found issue with atleast one chipset with this
warn_on, I would prefer retaining it, with a fix like above.

Thanks,
Venki


