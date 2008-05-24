Return-Path: <linux-kernel-owner+w=401wt.eu-S1761939AbYEXUpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761939AbYEXUpH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 16:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756456AbYEXUo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 16:44:57 -0400
Received: from gw.goop.org ([64.81.55.164]:48321 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbYEXUo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 16:44:56 -0400
Message-ID: <48387E29.50103@goop.org>
Date: Sat, 24 May 2008 21:44:25 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Zachary Amsden <zach@vmware.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0 of 4] mm+paravirt+xen: add pte read-modify-write abstraction
References: <patchbomb.1211552448@localhost> <alpine.LFD.1.10.0805231133130.3081@woody.linux-foundation.org> <48372C2F.1090704@goop.org> <alpine.LFD.1.10.0805241022210.3081@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805241022210.3081@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Fri, 23 May 2008, Jeremy Fitzhardinge wrote:
>   
>> Well, you could use it to update the page and protection bits while preserving
>> the AD bits, but I don't think that's very useful.
>>     
>
> It's not that it's not "very useful" - it's that it would be TOTALLY 
> WRONG.
>   

Sorry, I was using ironic understatement.  I meant "...while preserving 
the AD bits, but I think that would be totally fucking stupid".

    J
