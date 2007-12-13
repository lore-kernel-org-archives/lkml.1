Return-Path: <linux-kernel-owner+w=401wt.eu-S1763470AbXLMRbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763470AbXLMRbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762127AbXLMRbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:31:38 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:43872 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761079AbXLMRbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:31:37 -0500
Date: Thu, 13 Dec 2007 10:31:36 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>,
       Tony Luck <tony.luck@intel.com>, Matthew Wilcox <willy@debian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch_ptrace_stop
Message-ID: <20071213173136.GO26334@parisc-linux.org>
References: <20071213172926.GA423@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213172926.GA423@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 08:29:26PM +0300, Oleg Nesterov wrote:
> How is it possible that SIGKILL is blocked?

I *think* it's possible that kernel threads may block SIGKILL.
And I think init (pid 1) gets SIGKILL blocked.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
