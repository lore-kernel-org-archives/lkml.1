Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbYJHNdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbYJHNdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 09:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYJHNdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 09:33:36 -0400
Received: from igw3.br.ibm.com ([32.104.18.26]:39154 "EHLO igw3.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbYJHNdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 09:33:35 -0400
Subject: Re: [PATCH 1/4] integrity: TPM internel kernel interface
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, paulmck@linux.vnet.ibm.com
In-Reply-To: <alpine.LRH.1.10.0810081556390.13169@tundra.namei.org>
References: <cover.1223401603.git.zohar@linux.vnet.ibm.com>
	 <98178f6ceb8fa8d23153c6e7f94757f406771859.1223401604.git.zohar@linux.vnet.ibm.com>
	 <alpine.LRH.1.10.0810081556390.13169@tundra.namei.org>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 10:33:23 -0300
Message-Id: <1223472803.5742.21.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-08 at 16:00 +1100, James Morris wrote:
> On Tue, 7 Oct 2008, Mimi Zohar wrote:
> 
> > Based on discussions on the lkml mailing list, the TPM should be
> > built in, but when it is not builtin, the internal TPM kernel
> > interface did not protect itself from the removal of the TPM
> > driver, while being used. 
> 
> If the TPM driver should be built in, why is there an option to make it 
> modular?
> 
> - James

Hi James,

It's recommended that the TPM driver should be built-in when using IMA to make sure 
it's measuring the system as closely as possible to the start of the boot process,
but it's not necessarily true when using it to store keys, for example.

Rajiv


