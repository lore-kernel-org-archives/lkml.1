Return-Path: <linux-kernel-owner+w=401wt.eu-S1764059AbYFFGsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764059AbYFFGsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 02:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbYFFGr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 02:47:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbYFFGr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 02:47:56 -0400
Message-ID: <4848DD3C.9000001@redhat.com>
Date: Fri, 06 Jun 2008 08:46:20 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alasdair G Kergon <agk@redhat.com>
CC: Yan Li <elliot.li.tech@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ritesh Raj Sarraf <rrs@researchut.com>,
       Christophe Saout <christophe@saout.de>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
       rjmaomao@gmail.com, dm-crypt@saout.de
Subject: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
References: <20080602030738.GA7761@yantp.cn.ibm.com> <48439890.6030904@redhat.com> <20080602123145.GA8258@yantp.cn.ibm.com> <4843ECB8.4010002@redhat.com> <20080605224410.GA7584@yantp.cn.ibm.com>
In-Reply-To: <20080605224410.GA7584@yantp.cn.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yan Li wrote:
> On Mon, Jun 02, 2008 at 02:51:04PM +0200, Milan Broz wrote:
>> Patch for 2.6.24 kernel
>> Add cond_resched() to prevent stuck in big bio processing.
> 
> This patch actual has lead to performance _gain_.
hmmm, nice:)

> With patched kernel, soft lockup _no longer_ occurred.

Alasdair, please could you move this patch back to actual tree
and sent it upstream?

We have at least two separate reports confirming that it fixes
the problem.

Milan
--
mbroz@redhat.com

