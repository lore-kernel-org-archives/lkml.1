Return-Path: <linux-kernel-owner+w=401wt.eu-S1760114AbYFBL6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114AbYFBL6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbYFBL57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:57:59 -0400
Received: from gw.goop.org ([64.81.55.164]:52512 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbYFBL56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:57:58 -0400
Message-ID: <4843E01F.50609@goop.org>
Date: Mon, 02 Jun 2008 12:57:19 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Zachary Amsden <zach@vmware.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction	abstraction
References: <patchbomb.1212192268@localhost> <4deead25e96efc8ca783.1212192269@localhost> <20080602111339.GB18586@elte.hu>
In-Reply-To: <20080602111339.GB18586@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> +	/* Get the current pte state, but zero it out to make it
>> +	   non-present, preventing the hardware from asynchronously
>> +	   updating it. */
>>     
>
> please use standard and consistent comment style, similar to:
>   

OK.

    J
