Return-Path: <linux-kernel-owner+w=401wt.eu-S1764888AbYDYT3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764888AbYDYT3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYDYT3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 15:29:00 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34488 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbYDYT27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 15:28:59 -0400
Date: Fri, 25 Apr 2008 13:28:58 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 01/24] types: create <asm-generic/int-*.h>
Message-ID: <20080425192858.GM14990@parisc-linux.org>
References: <1209078352-7593-1-git-send-email-hpa@zytor.com> <1209078352-7593-2-git-send-email-hpa@zytor.com> <1209078352-7593-3-git-send-email-hpa@zytor.com> <alpine.LNX.1.10.0804252026040.20150@fbirervta.pbzchgretzou.qr> <alpine.LFD.1.10.0804251133100.2779@woody.linux-foundation.org> <20080425185251.GL14990@parisc-linux.org> <48122CB0.7020003@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48122CB0.7020003@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 12:10:40PM -0700, H. Peter Anvin wrote:
> Well, compatibility with userspace is probably one aspect of that. 
> x86-64 is the odd man out there, it defines __s64 as "long long" even 
> for userspace, even though int64_t from <stdint.h> is "long".  This, 
> IMO, is the Wrong Thing, but it's a separate set of changes.
> 
> The right thing to do is probably to always use "long long" in the 
> kernel, while defining __s64 et al as "long" on 64-bit platforms when 
> not under __KERNEL__.
> 
> Again, this is a separate set of changes from this patchset, which is 
> just a code transformation.

Understood, and agreed.  It just seemed like an opportune time to
mention the problem of printing a u64.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
