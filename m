Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbXJVQo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbXJVQo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 12:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbXJVQoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 12:44:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44753 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbXJVQoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 12:44:19 -0400
Message-ID: <471CD256.8000104@zytor.com>
Date: Mon, 22 Oct 2007 09:39:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@muc.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org> <46F04D53.6040903@zytor.com> <46F050E8.5020206@goop.org> <20071020164721.GA6614@Krystal> <471A49AA.6090407@zytor.com> <20071022154006.GA32642@Krystal>
In-Reply-To: <20071022154006.GA32642@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> Will fix. I noticed that it was because I had too much "register" char
> variables declared and used at the same time. Putting a "g" constraint
> gave the same result.
> 

"g" is the same as "rmi", which is probably *NOT* what you want.

Don't use "register" variables.  That's a poor workaround for using the 
proper constraints.

	-hpa
