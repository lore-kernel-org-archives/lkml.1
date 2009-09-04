Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbZIDRcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbZIDRcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 13:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757145AbZIDRcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 13:32:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38945 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134AbZIDRct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 13:32:49 -0400
Message-ID: <4AA13B14.20000@zytor.com>
Date: Fri, 04 Sep 2009 09:06:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       mingo@redhat.com, linux-kernel@vger.kernel.org,
       jeremy.fitzhardinge@citrix.com, stable@kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [tip:x86/asm] x86/i386: Make sure stack-protector segment base
 is cache aligned
References: <4AA01893.6000507@goop.org>	<tip-1ea0d14e480c245683927eecc03a70faf06e80c8@git.kernel.org>	<4AA02687.9080406@zytor.com>	<4AA02B02.7080101@goop.org>	<4AA031DE.2070109@zytor.com>	<20090903211805.GB12566@elte.hu> <20090904071524.0a7267ce@infradead.org>
In-Reply-To: <20090904071524.0a7267ce@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2009 07:15 AM, Arjan van de Ven wrote:
> 
> the other issue is that afaik we want the kernel to use the other
> register than userspace does...
> 

Yes, although it's a pretty marginal win on 32 bits as far as I know.
On 64 bits, not so.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

