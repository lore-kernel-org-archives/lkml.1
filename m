Return-Path: <linux-kernel-owner+w=401wt.eu-S1762643AbYEIPBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762643AbYEIPBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 11:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760771AbYEIPBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 11:01:38 -0400
Received: from relay1.sgi.com ([192.48.171.29]:57772 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760678AbYEIPBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 11:01:36 -0400
Message-ID: <48246749.9000101@sgi.com>
Date: Fri, 09 May 2008 08:01:29 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       bunk@kernel.org, linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
       Richard Henderson <rth@twiddle.net>, Paul Mackerras <paulus@samba.org>,
       Anton Blanchard <anton@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       "William L. Irwin" <wli@holomorphy.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] mm: define default cpu_to_node
References: <20080508230238.468043000@polaris-admin.engr.sgi.com> <20080508230238.649815000@polaris-admin.engr.sgi.com> <20080509052049.GA2161@linux-sh.org>
In-Reply-To: <20080509052049.GA2161@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> On Thu, May 08, 2008 at 04:02:39PM -0700, Mike Travis wrote:
>>   * Some architectures have CONFIG_NUMA=y but do not define a
>>     default cpu_to_node macro.  This provides the default in
>>     asm-generic/topology.h but it relies on the fact that
>>     cpu_to_node is a defined macro (and not an inline function).
>>
> NACK.. This isn't going to work anyways, cpu_to_node() is just where the
> first build error occurs. If you do this, then parent_node() is the next
> one to blow up, node_to_cpumask() after that, etc, etc. For now I've just
> stubbed the asm-generic/topology.h definitions in to asm-sh/topology.h.


Ok, Thanks!  I was looking at that but without being able to compile it,
it was just a wild swing towards the fence... ;-)  And your rationale makes
sense, if an arch really has numa topology then it should define what that is.

Cheers,
Mike

