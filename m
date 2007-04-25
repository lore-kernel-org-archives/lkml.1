Return-Path: <linux-kernel-owner+w=401wt.eu-S1422857AbXDYWgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422857AbXDYWgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993076AbXDYWgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:36:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:46258 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422857AbXDYWgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:36:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=jVLXOGkBZGoRlFIKroqXiXoWZfjX6BOMolMAgnMX4ptuXMpzzvNTUovmczlJF/cM0NwyVxCRyI1EkauIKIHdZL61xuW8Aehg69o40mSusQt+S78aaAGWw3ZPOg+xCiUs7PoFShGoD4gAxouTq6LKiqAxJh24D5E7fF0a4wYNGqo=
Message-ID: <462FD7E4.9020409@gmail.com>
Date: Thu, 26 Apr 2007 02:36:20 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
References: <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> <20070425072350.GA6866@ucw.cz> <20070425151825.GW3468@stusta.de> <20070425173405.GE17074@elf.ucw.cz> <20070425183934.GX3468@stusta.de> <alpine.LFD.0.98.0704251148110.9964@woody.linux-foundation.org> <20070425192512.GZ3468@stusta.de> <alpine.LFD.0.98.0704251231111.9964@woody.linux-foundation.org> <20070425200836.GB17387@elf.ucw.cz>
In-Reply-To: <20070425200836.GB17387@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

> STD needs to snapshot system, and then it needs devices to be
> suspended so that snapshot is consistent.


One question though, there are devices that can be suspended (broken
suspend) and restore in such a case wouldn't work at all. The only
possible way would be then to reinitialize the device instead of restore ?

Manu

