Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbYHGXXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbYHGXXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 19:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbYHGXXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 19:23:32 -0400
Received: from gw.goop.org ([64.81.55.164]:57231 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbYHGXXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 19:23:32 -0400
Message-ID: <489B83E5.7080605@goop.org>
Date: Thu, 07 Aug 2008 16:23:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@kernel.org>
CC: Zachary Amsden <zach@vmware.com>, Alok Kataria <akataria@vmware.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
References: <1218136365.23770.52.camel@alok-dev1>	 <489B6710.9000604@kernel.org>	 <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>	 <489B6A5C.8030400@kernel.org>	 <1218145344.20178.347.camel@bodhitayantram.eng.vmware.com>	 <489B6E83.7000202@kernel.org> <1218146154.20178.352.camel@bodhitayantram.eng.vmware.com> <489B7470.5030408@kernel.org>
In-Reply-To: <489B7470.5030408@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> That being said, the fixmap area being movable more than kind of 
> defeats a major point of the fixmap area; the addresses in it are no 
> longer fixed.

It's always been movable with CONFIG_PARAVIRT enabled.  Xen needs to 
reserve a hole at the top of the address space too.

    J
