Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbYJHFBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbYJHFBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 01:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbYJHFA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 01:00:58 -0400
Received: from tundra.namei.org ([65.99.196.166]:40269 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbYJHFA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 01:00:57 -0400
Date: Wed, 8 Oct 2008 16:00:02 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>, paulmck@linux.vnet.ibm.com,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/4] integrity: TPM internel kernel interface
In-Reply-To: <98178f6ceb8fa8d23153c6e7f94757f406771859.1223401604.git.zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.1.10.0810081556390.13169@tundra.namei.org>
References: <cover.1223401603.git.zohar@linux.vnet.ibm.com> <98178f6ceb8fa8d23153c6e7f94757f406771859.1223401604.git.zohar@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008, Mimi Zohar wrote:

> Based on discussions on the lkml mailing list, the TPM should be
> built in, but when it is not builtin, the internal TPM kernel
> interface did not protect itself from the removal of the TPM
> driver, while being used. 

If the TPM driver should be built in, why is there an option to make it 
modular?

- James
-- 
James Morris
<jmorris@namei.org>
