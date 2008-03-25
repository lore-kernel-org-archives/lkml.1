Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbYCYS15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbYCYS15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 14:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbYCYS1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 14:27:48 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53634 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbYCYS1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:27:47 -0400
Subject: Re: larger default page sizes...
From: Dave Hansen <haveblue@us.ibm.com>
To: Paul Mackerras <paulus@samba.org>
Cc: David Miller <davem@davemloft.net>, clameter@sgi.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <18408.29107.709577.374424@cargo.ozlabs.ibm.com>
References: <Pine.LNX.4.64.0803211037140.18671@schroedinger.engr.sgi.com>
	 <20080321.145712.198736315.davem@davemloft.net>
	 <Pine.LNX.4.64.0803241121090.3002@schroedinger.engr.sgi.com>
	 <20080324.133722.38645342.davem@davemloft.net>
	 <18408.29107.709577.374424@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 25 Mar 2008 11:27:45 -0700
Message-Id: <1206469665.27393.19.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-25 at 14:29 +1100, Paul Mackerras wrote:
> 4kB pages:      444.051s user + 34.406s system time
> 64kB pages:     419.963s user + 16.869s system time
> 
> That's nearly 10% faster with 64kB pages -- on a kernel compile.

Can you do the same thing with the 4k MMU pages and 64k PAGE_SIZE?
Wouldn't that easily break out whether the advantage is from the TLB or
from less kernel overhead?

-- Dave

