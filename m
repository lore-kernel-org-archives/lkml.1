Return-Path: <linux-kernel-owner+w=401wt.eu-S1760977AbYAJTzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977AbYAJTzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbYAJTzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:55:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108AbYAJTzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:55:16 -0500
Message-ID: <4786780F.90302@redhat.com>
Date: Thu, 10 Jan 2008 14:54:55 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: x86: Add the "print code before the trapping instruction" feature
 to 64 bit
References: <20080110084739.5ba72522@laptopd505.fenrus.org>
In-Reply-To: <20080110084739.5ba72522@laptopd505.fenrus.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2008 11:47 AM, Arjan van de Ven wrote:
> Subject: x86: Add the "print code before the trapping instruction" feature to 64 bit
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> The 32 bit x86 tree has a very useful feature that prints the Code: line
> for the code even before the trapping instrution (and the start of the
> trapping instruction is then denoted with a <>). Unfortunately, the 64 bit
> x86 tree does not yet have this feature, making diagnosing backtraces harder
> than needed.
> 
> This patch adds this feature in the same was as the 32 bit tree has
> (including the same kernel boot parameter), and including a bugfix
> to make the code use probe_kernel_address() rarther than a buggy (deadlocking)
> __get_user.
> 

If this get accepted I can stop ignoring x86_64 oops reports...

