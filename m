Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbYDJDeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbYDJDeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 23:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbYDJDdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 23:33:55 -0400
Received: from ozlabs.org ([203.10.76.45]:44586 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbYDJDdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 23:33:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 16/17] Immediate Values - Documentation
Date: Thu, 10 Apr 2008 13:33:35 +1000
User-Agent: KMail/1.9.9
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Adrian Bunk <bunk@stusta.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, akpm@osdl.org
References: <20080409150829.855195878@polymtl.ca> <20080409152052.245356400@polymtl.ca>
In-Reply-To: <20080409152052.245356400@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804101333.36419.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 April 2008 01:08:45 Mathieu Desnoyers wrote:
> If you have to read the immediate values from a function declared as
> __init or __exit, you should explicitly use _imv_read(), which will fall
> back on a global variable read. Failing to do so will leave a reference to
> the __init section after it is freed (it would generate a modpost
> warning).

That's a real usability wart.  Couldn't we skip these in the patching loop if 
required and revert so noone can make this mistake?

Thanks,
Rusty.
