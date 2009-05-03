Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbZECSmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbZECSmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 14:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbZECSmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 14:42:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55411 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbZECSmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 14:42:09 -0400
Message-ID: <49FDE47C.7090607@zytor.com>
Date: Sun, 03 May 2009 11:37:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Tobias Doerffel <tobias.doerffel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Specific support for Intel Atom architecture
References: <200904301408.09370.tobias.doerffel@gmail.com> <20090430154051.GA3346@elte.hu> <49F9DB70.2050906@zytor.com> <20090503053821.GI570@1wt.eu> <20090503075346.63fc7211@infradead.org> <20090503183038.GA8571@1wt.eu>
In-Reply-To: <20090503183038.GA8571@1wt.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
>>>>
>>>> $(call cc-option,-march=atom,-march=i686)
>>> if it's an in-order architecture, wouldn't it be better to tune for
>>> i386 or i486 instead ?
>> -march isn't about tuning, it's about supported instructions.
> 
> agreed, but unless specified otherwise using -mtune, -march also sets
> default tuning for the indicated CPU. At least in my experience.
> 
>> The right line is
>> $(call cc-option,-march=atom,-march=core2)

For really old gcc's (we support all the way back to gcc 3.2 still)
-march=core2 might not work either.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

