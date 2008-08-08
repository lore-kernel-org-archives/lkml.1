Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbYHHAcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbYHHAcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbYHHAcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:32:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51631 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbYHHAcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:32:32 -0400
Message-ID: <489B934C.90408@kernel.org>
Date: Thu, 07 Aug 2008 17:29:00 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Zachary Amsden <zach@vmware.com>, Alok Kataria <akataria@vmware.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
References: <1218136365.23770.52.camel@alok-dev1>	 <489B6710.9000604@kernel.org> <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com> <489B836A.3050209@goop.org> <489B84EF.6050009@kernel.org> <489B8948.6060003@goop.org> <489B8A68.10900@kernel.org> <489B8EF4.1030105@goop.org> <489B8FAD.4090904@kernel.org> <489B9208.2050802@goop.org>
In-Reply-To: <489B9208.2050802@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
>> Yes, and we should add a symbol for the bottom of the 1:1 area as well 
>> (to disambiguate it from TASK_SIZE).
> 
> Well, that's already called "PAGE_OFFSET".  64-bit needs to be careful 
> about the distinction anyway, because there's the sign extension hole 
> between user and kernel space.  Xen squeezes itself in just above the 
> hole, so I moved PAGE_OFFSET up accordingly.

Ah, that explains that strange offset.  I was wondering about that.

	-hpa

