Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbYKUBdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbYKUBdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 20:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYKUBdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 20:33:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45326 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbYKUBdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 20:33:40 -0500
Message-ID: <49260F1F.4070107@zytor.com>
Date: Thu, 20 Nov 2008 17:30:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 30 of 38] xen: implement io_apic_ops
References: <patchbomb.1226603398@abulafia.goop.org> <d103c0da2fa147ac31af.1226603428@abulafia.goop.org> <20081120093506.GB6885@elte.hu> <492597B9.8070506@goop.org> <20081120192218.GF3955@elte.hu>
In-Reply-To: <20081120192218.GF3955@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> it certainly looks thin enough to me although i'm really not sure we 
> want to virtualize at the IO-APIC level. Peter, what's your 
> opinion/preference?
> 

Not having studied the Xen code in detail, but my assumption would be
that we should allocate this at the IRQ chip level rather than violating
the IO-APIC code.  I also (as previously discussed) really want to see a
dynamic allocator for IRQ numbers like PowerPC already has.

	-hpa
