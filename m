Return-Path: <linux-kernel-owner+w=401wt.eu-S1765643AbXHASfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765643AbXHASfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758004AbXHASfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:35:24 -0400
Received: from il.qumranet.com ([82.166.9.18]:59787 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757305AbXHASfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:35:23 -0400
Message-ID: <46B0D273.4050209@qumranet.com>
Date: Wed, 01 Aug 2007 21:35:31 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Yaniv Kamay <yaniv@qumranet.com>
Subject: Re: [PATCH -mm] Fix defined but not used warning in drivers/kvm/vmx.c
References: <20070731230932.a9459617.akpm@linux-foundation.org> <46B0974E.3030703@googlemail.com>
In-Reply-To: <46B0974E.3030703@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Hi,
>
> move_msr_up() is used only on X86_64 and generates a warning on !X86_64
>
> ...
>
> drivers/kvm/vmx.c:548: warning: 'move_msr_up' defined but not used
>   

Applied, thanks.

> ---
>
> PS: Btw Avi why do you think I'm mysterious ?:)
> ...
>
> git-kvm.patch:    Noted by the mysterious Gabriel C.
>
>   

Well, the C surname (maybe you're related to the programming language?) 
and the email address.


-- 
error compiling committee.c: too many arguments to function

