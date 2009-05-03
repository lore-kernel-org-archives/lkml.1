Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbZECGyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbZECGyh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 02:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbZECGy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 02:54:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46397 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZECGy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 02:54:27 -0400
Message-ID: <49FD3E56.3010803@zytor.com>
Date: Sat, 02 May 2009 23:48:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Ingo Molnar <mingo@elte.hu>, Tobias Doerffel <tobias.doerffel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Specific support for Intel Atom architecture
References: <200904301408.09370.tobias.doerffel@gmail.com> <20090430154051.GA3346@elte.hu> <49F9DB70.2050906@zytor.com> <20090503053821.GI570@1wt.eu>
In-Reply-To: <20090503053821.GI570@1wt.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
>>
>> $(call cc-option,-march=atom,-march=i686)
> 
> if it's an in-order architecture, wouldn't it be better to tune for i386
> or i486 instead ?
> 

Possibly.  It would be worth measuring.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

