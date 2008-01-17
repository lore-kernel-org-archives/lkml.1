Return-Path: <linux-kernel-owner+w=401wt.eu-S1760308AbYAQXQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308AbYAQXQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757427AbYAQXQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:16:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:2227 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756786AbYAQXQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:16:45 -0500
X-ExtLoop1: 1
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [-mm Patch] uml: fix a building error
Date: Thu, 17 Jan 2008 15:17:38 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE62B45A@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080117230802.GA9360@c2.user-mode-linux.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [-mm Patch] uml: fix a building error
Thread-Index: AchZXeXdVfhgym+bRJ6ZH6wN6kzz8gAANuGw
References: <20080117105606.ff89e9e9.akpm@linux-foundation.org> <924EFEDD5F540B4284297C4DC59F3DEE5E90DF@orsmsx423.amr.corp.intel.com> <20080117211437.GA7573@c2.user-mode-linux.org> <20080117214150.GA25872@linux-os.sc.intel.com> <20080117230802.GA9360@c2.user-mode-linux.org>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Jeff Dike" <jdike@addtoit.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       "WANG Cong" <xiyou.wangcong@gmail.com>, <linux-kernel@vger.kernel.org>,
       <user-mode-linux-devel@lists.sourceforge.net>,
       "David Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
X-OriginalArrivalTime: 17 Jan 2008 23:16:43.0106 (UTC) FILETIME=[059DEC20:01C8595F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Jeff Dike [mailto:jdike@addtoit.com] 
>Sent: Thursday, January 17, 2008 3:08 PM
>To: Pallipadi, Venkatesh
>Cc: Andrew Morton; Mariusz Kozlowski; WANG Cong; 
>linux-kernel@vger.kernel.org; 
>user-mode-linux-devel@lists.sourceforge.net; David Miller; 
>sparclinux@vger.kernel.org; Ingo Molnar; Thomas Gleixner
>Subject: Re: [-mm Patch] uml: fix a building error
>
>On Thu, Jan 17, 2008 at 01:41:50PM -0800, Venki Pallipadi wrote:
>> > And while we're on the subject, what's the deal with these, in
>> > include/asm-x86/io.h?
>> > 
>> > #define ioremap_wc ioremap_wc
>> > #define unxlate_dev_mem_ptr unxlate_dev_mem_ptr
>> > 
>> 
>> If archs want to override the defaults for these two 
>functions, they define
>> the above and then include asm-generic/iomap.h.
>
>That wasn't really the question.
>
>#define X X
>
>is a no-op, yes?
>

Later there is code in generic.h which is doing
#ifndef ioremap_wc
#define ioremap_wc ioremap_nocache
#endif
	

Thanks,
Venki
