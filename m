Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbZENRpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbZENRpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 13:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbZENRpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 13:45:33 -0400
Received: from gw.goop.org ([64.81.55.164]:49101 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbZENRpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 13:45:32 -0400
Message-ID: <4A0C58BB.3090303@goop.org>
Date: Thu, 14 May 2009 10:45:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, Jun Nakajima <jun.nakajima@intel.com>,
       Xiaohui Xin <xiaohui.xin@intel.com>, Xin Li <xin.li@intel.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Performance overhead of paravirt_ops on	 nativeidentified
References: <4A0B62F7.5030802@goop.org> <4A0BED040200007800000DB0@vpn.id2.novell.com>
In-Reply-To: <4A0BED040200007800000DB0@vpn.id2.novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Wouldn't a third solution be to use ticket spinlocks everywhere, i.e. eliminate
> the current indirection, and replace it by an indirection for just the contention
> case? As I view it, the problem for Xen aren't really the ticket locks by
> themselves, but rather the extra spinning involved, which is of concern only
> if a lock is contended. We're using ticket locks quite happily in our kernels,
> with directed instead of global wakeup from the unlock path.
Do you have a patch to illustrate what you mean?  How do you keep track 
of the target vcpu for the directed wakeup?  Are you using the 
event-poll mechanism to block?

    J
