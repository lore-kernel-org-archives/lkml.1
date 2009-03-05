Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbZCETok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbZCETok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbZCEToc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:44:32 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46471 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368AbZCETob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:44:31 -0500
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090305174037.GA2274@x200.localdomain>
References: <20090305163857.0C18F3FD@kernel>
	 <20090305174037.GA2274@x200.localdomain>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 11:44:16 -0800
Message-Id: <1236282256.22399.102.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 20:40 +0300, Alexey Dobriyan wrote:
> * without largely useless "special file" messages
>   (what's so special about it?)

Thanks for pointing this out, Alexey.  After going and looking at these,
I realized that this changed sometime in the last 5 or 6 years. :)

My f_op approach works for these even without the special_file()
check.  

-- Dave

