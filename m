Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbXBKBmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbXBKBmV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 20:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbXBKBmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 20:42:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:14637 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbXBKBmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 20:42:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=BHTbLvWRckK7EwYTkHzznuZ3/DD/CL4jRp7uUok6HLjW0ONGR3Sz6LrLutyPqq3/o7uL0sSloN6uaOM9Gx7a5g9ms4Fhdu6thBHBtDoMOrzHTlqBFVrZUGnBZpQRSjFzCX/JsWNuRVM9gnR85jB9TcNVHF5ep87x/lGTkPMDiMA=
Date: Sun, 11 Feb 2007 03:40:47 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Miguel Ojeda <maxextreme@gmail.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: 20-rc6-mm3 - BUG: at arch/i386/mm/highmem.c:52 kmap_atomic()
Message-ID: <20070211034047.GE7501@slug>
References: <653402b90702101145l2d5edbf9mc8873b62d377f1bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <653402b90702101145l2d5edbf9mc8873b62d377f1bf@mail.gmail.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 08:45:26PM +0100, Miguel Ojeda wrote:
> When I was testing some stuff at 2.6.20-rc6-mm3 I found this at dmesg
> multiple times.
> 
Could you try this hotfix
http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/hot-fixes/ntfs-kmap_atomic-atomicity-fix.patch
and see if it works for you?

Regards,
Frederik
