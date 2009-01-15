Return-Path: <linux-kernel-owner+w=401wt.eu-S1759667AbZAORKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbZAORKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 12:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbZAORKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 12:10:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54174 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbZAORKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 12:10:45 -0500
Message-ID: <496F6DFC.90006@zytor.com>
Date: Thu, 15 Jan 2009 09:10:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: simplify HIGHMEM-related Kconfig entries
References: <496DE927.76E4.0078.0@novell.com> <496E3F7D.2060908@zytor.com> <496F0796.76E4.0078.0@novell.com> <20090115085728.GA28607@elte.hu>
In-Reply-To: <20090115085728.GA28607@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>>
>>> 	No highmem	- No highmem, no PAE
>>> 	HIGHMEM4G	- Highmem, no PAE
>>> 	HIGHMEM64G	- Highmem, PAE
>>>
>>> So X86_PAE and HIGHMEM4G is a bit of a contradiction.  I haven't looked 
>>> at the logic in detail, or remember offhand if there have been any 
>>> weakening of the definitions above; e.g. someone could have implemented 
>>> a way to do PAE without highmem, to get access to the NX bits.
>> Exactly - .23 made PAE an independently selectable option (in 
>> particular, the no-highmem+PAE combination is now valid), but I can't 
>> see why it added the !HIGHMEM4G dependency.
> 
> There's no deep reason, it just has never really been tested that way. I 
> think we should try it.

If so, what would be the difference between HIGHMEM4G and HIGHMEM64G in
that case at all?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

