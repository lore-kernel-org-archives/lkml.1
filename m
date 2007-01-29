Return-Path: <linux-kernel-owner+w=401wt.eu-S933286AbXA2I7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286AbXA2I7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 03:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933289AbXA2I7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 03:59:50 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54515 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933286AbXA2I7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 03:59:50 -0500
Date: Mon, 29 Jan 2007 00:59:40 -0800
From: Andrew Morton <akpm@osdl.org>
To: Andi Kleen <ak@suse.de>
Cc: "Parag Warudkar" <parag.warudkar@gmail.com>, thunder7@xs4all.nl,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm1: linker error with arch_setup_additional_pages
Message-Id: <20070129005940.04c3d6d1.akpm@osdl.org>
In-Reply-To: <200701290351.54270.ak@suse.de>
References: <82e4877d0701280834n75d3d0d3ja7a35d5ea0e7fa4f@mail.gmail.com>
	<82e4877d0701281444h333c581fr66d60cca9d03749d@mail.gmail.com>
	<200701290351.54270.ak@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 03:51:54 +0100
Andi Kleen <ak@suse.de> wrote:

> 
> > I think the easy and correct fix for this situation is defining
> > CONFIG_ARCH_HAS_SETUP_ADDITIONAL_PAGES on x86_64 only if
> > IA32_EMULATION is defined. (Because x86_64 proper doesn't seem to
> > require arch_setup_additional_pages() only IA32 emulation requires
> > it.)
> >
> > The patch below should fix it. (Please use attachment - less chance of
> > whitespace issues. Sorry no control over mail client atm)
> 
> A more elegant solution would be to do away with the CONFIG
> and switch to a weak function in the caller.
> 

Now why didn't I think of that?
