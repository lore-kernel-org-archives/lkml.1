Return-Path: <linux-kernel-owner+w=401wt.eu-S1760193AbYDKO7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193AbYDKO7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 10:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759463AbYDKO7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 10:59:04 -0400
Received: from ozlabs.org ([203.10.76.45]:41411 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759295AbYDKO7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 10:59:03 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 12/17] Immediate Values - Kconfig menu in EMBEDDED (updated)
Date: Fri, 11 Apr 2008 07:54:09 +1000
User-Agent: KMail/1.9.9
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Adrian Bunk <bunk@stusta.de>, Christoph Hellwig <hch@infradead.org>,
       akpm@osdl.org
References: <20080409150829.855195878@polymtl.ca> <200804101323.56697.rusty@rustcorp.com.au> <20080410193226.GA22894@Krystal>
In-Reply-To: <20080410193226.GA22894@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804110754.10706.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 April 2008 05:32:26 Mathieu Desnoyers wrote:
> +	  It consumes slightly more memory and requires to modify the
> +	  instruction stream each time a variable is updated.

Sorry, I missed this grammar bug last time.  Also, probable don't want to 
scare someone that we're changing instructions on every var change :)

	It consumes slightly more memory and modifies the instruction
	stream each time any specially-marked variable is updated.

Thanks,
Rusty.
