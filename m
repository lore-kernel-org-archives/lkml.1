Return-Path: <linux-kernel-owner+w=401wt.eu-S933916AbXCPQdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916AbXCPQdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933937AbXCPQdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:33:43 -0400
Received: from gw.goop.org ([64.81.55.164]:41668 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933916AbXCPQdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:33:42 -0400
Message-ID: <45FAC6E6.5090000@goop.org>
Date: Fri, 16 Mar 2007 09:33:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [RFC, PATCH] Fixup COMPAT_VDSO to work with CONFIG_PARAVIRT
References: <45FA054F.6020107@vmware.com> <m17itho10v.fsf@ebiederm.dsl.xmission.com> <45FAC4EF.4060305@goop.org> <20070316163118.GA12999@elte.hu>
In-Reply-To: <20070316163118.GA12999@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> that's what is the case right now, but much of the intention behind the 
> vma based vDSO is to enable per-process randomized vdso locations, and 
> various distributions do that. So the 'modern' vDSO concept is very much 
> relocatable.

No, the point is that it never needs relocating.  The kernel can map it
anywhere and userspace can cope.  Its only the broken glibcs which
require relocation.

    J
