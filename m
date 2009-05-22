Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbZEVUNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbZEVUNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 16:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbZEVUNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:13:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39548 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465AbZEVUM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:12:59 -0400
Message-ID: <4A170713.402@zytor.com>
Date: Fri, 22 May 2009 13:12:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Rakib Mullick <rakib.mullick@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86,APIC: Detect lapic_is_integrated() once - use on
 and on.
References: <b9df5fa10905220631y7b1a094dn9a6e13de1b9c43af@mail.gmail.com> <20090522200239.GD5354@lenovo>
In-Reply-To: <20090522200239.GD5354@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> 
> Hi Rakib,
> 
> actually this change could be dangerous. I don't
> remember if I saw mixed configuration at all but
> I would not be that sure that we will never met it.
> 
> Peter? Ingo? Yinghai? Maciej?
> 

That seems unlikely in the extreme.  To the best of my knowledge, only
486s ever used the external APICs.

	-hpa
