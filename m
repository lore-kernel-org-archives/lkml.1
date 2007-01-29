Return-Path: <linux-kernel-owner+w=401wt.eu-S933271AbXA2IrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbXA2IrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 03:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933272AbXA2IrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 03:47:14 -0500
Received: from mail.suse.de ([195.135.220.2]:43109 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271AbXA2IrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 03:47:14 -0500
From: Andi Kleen <ak@suse.de>
To: "Parag Warudkar" <parag.warudkar@gmail.com>
Subject: Re: 2.6.20-rc6-mm1: linker error with arch_setup_additional_pages
Date: Mon, 29 Jan 2007 03:51:54 +0100
User-Agent: KMail/1.9.1
Cc: thunder7@xs4all.nl, "akpm@osdl.org" <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
References: <82e4877d0701280834n75d3d0d3ja7a35d5ea0e7fa4f@mail.gmail.com> <82e4877d0701281444h333c581fr66d60cca9d03749d@mail.gmail.com>
In-Reply-To: <82e4877d0701281444h333c581fr66d60cca9d03749d@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200701290351.54270.ak@suse.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I think the easy and correct fix for this situation is defining
> CONFIG_ARCH_HAS_SETUP_ADDITIONAL_PAGES on x86_64 only if
> IA32_EMULATION is defined. (Because x86_64 proper doesn't seem to
> require arch_setup_additional_pages() only IA32 emulation requires
> it.)
>
> The patch below should fix it. (Please use attachment - less chance of
> whitespace issues. Sorry no control over mail client atm)

A more elegant solution would be to do away with the CONFIG
and switch to a weak function in the caller.

-Andi
