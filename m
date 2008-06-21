Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbYFUCAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbYFUCAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 22:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYFUCAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 22:00:37 -0400
Received: from gw.goop.org ([64.81.55.164]:35650 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbYFUCAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 22:00:36 -0400
Message-ID: <485C60C1.2050200@goop.org>
Date: Fri, 20 Jun 2008 19:00:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Roland McGrath <roland@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Various x86 syscall mechanisms
References: <485C2875.2050204@goop.org> <485C4B0E.2090704@zytor.com>
In-Reply-To: <485C4B0E.2090704@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> The reason is that not all 64-bit processors (i.e. K8) support a 
> 32-bit sysenter in long mode (i.e. with a 64-bit kernel.)

OK, so compat 32-bit processes would use syscall in that case, even if 
they wouldn't on a 32-bit kernel?

>   sysenter is *always* entered from the vdso, since the return address 
> is lost and this is also where a 64-bit kernel can put a syscall.
>
> There is no reason we couldn't do syscall for 32-bit native, but the 
> only processor that would benefit would be K7, and that's far enough 
> in the past that I don't think anyone cares enough.

OK, good.

> Note that long mode syscall is different from protected mode syscall, 
> even in 32-bit compatibility mode.  The long mode variant is a lot saner.

You mean that syscall arriving in long mode ring0 is saner than syscall 
arriving in protected mode ring0?

    J
