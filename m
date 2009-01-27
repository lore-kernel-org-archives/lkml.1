Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbZA0IYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbZA0IYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 03:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZA0IYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 03:24:25 -0500
Received: from gw.goop.org ([64.81.55.164]:42724 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbZA0IYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 03:24:25 -0500
Message-ID: <497EC4B6.3060805@goop.org>
Date: Tue, 27 Jan 2009 00:24:22 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Zachary Amsden <zach@vmware.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "jeremy@xensource.com" <jeremy@xensource.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
References: <20090120112634.GA20858@elte.hu> <20090120140324.GA26424@elte.hu> <49763806.5090009@goop.org> <20090120205653.GA19710@elte.hu> <20090121072718.GN24891@wotan.suse.de> <4977A051.8050203@goop.org> <1232663311.16317.176.camel@bodhitayantram.eng.vmware.com> <4978F6C6.3090003@goop.org> <1232664907.16317.182.camel@bodhitayantram.eng.vmware.com> <49790BCC.1040807@goop.org> <20090127075912.GA6551@elte.hu>
In-Reply-To: <20090127075912.GA6551@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> This is a very serious paravirt_ops slowdown affecting the native kernel's 
> performance to the tune of 5-10% in certain workloads.
>
> It's been about 2 years ago that paravirt_ops went upstream, when you told 
> us that something like this would never happen, that paravirt_ops is 
> designed so flexibly that it will never hinder the native kernel - and if 
> it does it will be easy to fix it. Now is the time to fulfill that 
> promise.
>   

Yep, working on it.

    J
