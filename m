Return-Path: <linux-kernel-owner+w=401wt.eu-S934030AbZJIRIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030AbZJIRIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 13:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932230AbZJIRIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 13:08:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53182 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110AbZJIRIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 13:08:43 -0400
Date: Fri, 9 Oct 2009 13:08:04 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andreas Mohr <andi@lisas.de>, Kyle McMartin <kyle@mcmartin.ca>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.32-rc3: floating-point build failure (undefined reference
	to `__udivdi3' in menu governor)
Message-ID: <20091009170803.GE11702@bombadil.infradead.org>
References: <20091007104125.GA1449@rhlx01.hs-esslingen.de> <4ACCA44B.3070706@linux.intel.com> <20091007173457.GA25415@rhlx01.hs-esslingen.de> <20091007174553.GC11702@bombadil.infradead.org> <20091009160123.GA14808@rhlx01.hs-esslingen.de> <4ACF658D.4010605@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACF658D.4010605@linux.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 09:32:13AM -0700, Arjan van de Ven wrote:
>> Hmpf. Rather stuck now, ain'tcha, given that gcc 3.2.3 doesn't even have those?
>>
>
> wonder if making a new define with the value of RESOLUTION * DECAY
> (the actual value obviously) convinces your gcc that it really is a power of two ?
>

It shouldn't. Maybe just add a BUILD_BUG_ON and change the divide to a
shift directly. How expected are these values to ever change, really?

-Kyle
