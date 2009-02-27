Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbZB0VlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbZB0VlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbZB0VlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:41:08 -0500
Received: from gw.goop.org ([64.81.55.164]:56441 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049AbZB0VlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:41:08 -0500
Message-ID: <49A85DED.9050605@goop.org>
Date: Fri, 27 Feb 2009 13:41:01 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: add brk allocation for very, very early allocations
References: <49A829CE.9020509@goop.org> <49A84C5A.3020304@kernel.org> <49A855B7.4090204@zytor.com> <49A858E8.3070707@goop.org> <49A85AF8.8030009@zytor.com>
In-Reply-To: <49A85AF8.8030009@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Cool; just wanted it noted what the rules were.  Even more so the reason
> to fold as many possible uses as possible into this new mechanism.
>   

Yes, I just converted i386 pagetable construction and dmi_alloc().  
Boots under qemu.

> P.S. Could you send me the updates to the dom0 patches you said you had?
>   

Was just tidying them up for posting but got slightly sidetracked.  (The 
TSS/io-bitmap changes are a prelude to the dom0 patches though.)

    J
