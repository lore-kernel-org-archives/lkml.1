Return-Path: <linux-kernel-owner+w=401wt.eu-S1765545AbYARUBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765545AbYARUBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765333AbYARUBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:01:23 -0500
Received: from smtprelay13.ispgateway.de ([80.67.29.43]:45403 "EHLO
	smtprelay13.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765184AbYARUBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:01:21 -0500
From: Ingo Oeser <ioe-lkml@rameria.de>
To: travis@sgi.com
Subject: Re: [PATCH 4/5] x86: Add config variables for SMP_MAX
Date: Fri, 18 Jan 2008 21:04:21 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu, Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <20080118183011.354965000@sgi.com> <20080118183011.917801000@sgi.com>
In-Reply-To: <20080118183011.917801000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801182104.22486.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Friday 18 January 2008, travis@sgi.com wrote:
> +config THREAD_ORDER
> +	int "Kernel stack size (in page order)"
> +	range 1 3
> +	depends on X86_64_SMP
> +	default "3" if X86_SMP_MAX
> +	default "1"
> +	help
> +	  Increases kernel stack size.
> +

Could you please elaborate, why this is needed and put more info about
this requirement into this patch description?

People worked hard to push data allocation from stack to heap to make 
THREAD_ORDER of 0 and 1 possible. So why increase it again and why does this
help scalability?

Many thanks and Best Regards

Ingo Oeser, puzzled a bit :-)
