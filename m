Return-Path: <linux-kernel-owner+w=401wt.eu-S1161294AbXBGWb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161294AbXBGWb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161466AbXBGWb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:31:59 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:36512 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161294AbXBGWb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:31:58 -0500
Message-ID: <45CA535D.1080700@vmware.com>
Date: Wed, 07 Feb 2007 14:31:57 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 9/11] Panic delay fix
References: <200702060353.l163rUmj000771@zach-dev.vmware.com>	 <20070206122729.GC47229@muc.de> <45C8FA2D.6010706@vmware.com> <d120d5000702070658l1c018565n34a6d8814a20184d@mail.gmail.com>
In-Reply-To: <d120d5000702070658l1c018565n34a6d8814a20184d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
>
> I am confused - does i8042 talk to a virtual or real hardware here? In
> any case I think you need to fix kernel/panic.c to have proper
> (m)delay, not mess with i8042.

I think I need to fix both of them actually.  This is virtual hardware, 
but when you grab focus on a VM, the virtual hardware gets reflected to 
the actual physical keyboard.  Driving physical hardware that fast is bad.

Zach

