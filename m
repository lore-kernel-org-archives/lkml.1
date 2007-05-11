Return-Path: <linux-kernel-owner+w=401wt.eu-S1761315AbXEKUZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761315AbXEKUZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757217AbXEKUZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:25:09 -0400
Received: from gw.goop.org ([64.81.55.164]:46355 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756123AbXEKUZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:25:07 -0400
Message-ID: <4644D11C.2040207@goop.org>
Date: Fri, 11 May 2007 13:25:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Zachary Amsden <zach@vmware.com>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 02/28]xen: Add nosegneg capability to the vsyscall page
 notes
References: <20070511200744.4BC1A1F8512@magilla.localdomain>
In-Reply-To: <20070511200744.4BC1A1F8512@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
>> + * It should contain:
>> + *	hwcap 0 nosegneg
>> + * to match the mapping of bit to name that we give here.
>>     
>
> This comment still needs s/0/1/ to match the code.  Given that the actual
> bit is now defined in the macro in another file, perhaps the comment should
> say more about it than just a magic 1.
>   

Crap, I thought I had 1) understood it, and 2) fixed it.  I guess I
skipped 1 and therefore overlooked 2.

    J
