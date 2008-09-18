Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYIRRZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYIRRZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 13:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbYIRRZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 13:25:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56941 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbYIRRZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 13:25:50 -0400
Message-ID: <48D28EF7.4080504@zytor.com>
Date: Thu, 18 Sep 2008 10:25:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v3)
References: <48D21BA3.76E4.0078.0@novell.com> <20080918071852.GA7639@elte.hu> <20080918091003.GA3751@elte.hu> <48D23BF6.76E4.0078.0@novell.com> <48D272F9.3090001@zytor.com> <48D29554.76E4.0078.0@novell.com>
In-Reply-To: <48D29554.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>
>> There is no reason for this to be #ifdef'd; but it should be conditional 
>> on this information not being otherwise available (which will always be 
>> the case on 64 bits), I would assume.  If we are setting a value there, 
>> we should presumably also set 32 in the other case.
> 
> It does get set to 32 first (and only for 32-bits - 64bits didn't set any
> default so far, so I didn't want to make it to now), and the code fragment
> above updates that default after feature flags have been obtained, but
> before other capabilities (including the phys/virt bit widths) are being
> gathered.
> 

Set the default on 64 bits as well.  It's cleaner to not leave a 
pointless #ifdef in there.

	-hpa

