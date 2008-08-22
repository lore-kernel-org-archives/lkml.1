Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbYHVW7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbYHVW7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 18:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYHVW7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 18:59:16 -0400
Received: from tundra.namei.org ([65.99.196.166]:45468 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbYHVW7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 18:59:15 -0400
Date: Sat, 23 Aug 2008 08:58:57 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       zohar@us.ibm.com, dvelarde@us.ibm.com, safford@us.ibm.com
Subject: Re: [PATCH] TPM: update char dev BKL pushdown
In-Reply-To: <20080822161908.GA24791@us.ibm.com>
Message-ID: <alpine.LRH.1.10.0808230858070.24779@tundra.namei.org>
References: <1219421072.4765.7.camel@blackbox> <20080822161908.GA24791@us.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008, Serge E. Hallyn wrote:

> Quoting Rajiv Andrade (srajiv@linux.vnet.ibm.com):
> > This patch removes the BKL calls from the TPM driver, which
> > were added in the overall misc-char-dev-BKL-pushdown.patch,
> > as they are not needed. Changed num_opens from an int to atomic_t.
> > 
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> 
> Yes, this patch is good.  
> 
> It would also be good to rename num_opens.  Note that it is always
> either 0 or 1, and indicates whether someone has opened the chip.
> So 'is_open' may make more sense.

And use atomic_set() instead of atomic_inc().



- James
-- 
James Morris
<jmorris@namei.org>
