Return-Path: <linux-kernel-owner+w=401wt.eu-S965691AbXJPUdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965691AbXJPUdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964780AbXJPUc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:32:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:6481 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964949AbXJPUc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:32:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rFIHxYuB8ZcJmS1q48ai3la5lEWXEQReraL3aUIXQ0CC9CPAvfZRmdzj4LaZ7u+uMAixp945rvf2I/EgE0cEE2vY39/DXT4kxNelaN7lUpracswCczKijBLiod5RO+49Z7TNlo0x4d1UqcGVKg/tDmB4s4IUPbVLUR+8U1nzOz4=
Message-ID: <21d7e9970710161332h7694579dp277ce774b0ce3956@mail.gmail.com>
Date: Wed, 17 Oct 2007 06:32:55 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Jeremy Katz" <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       davej@redhat.com, "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
In-Reply-To: <alpine.LFD.0.999.0710161208340.6887@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192481110-9299-1-git-send-email-katzj@redhat.com>
	 <20071015210737.GA15293@khazad-dum.debian.net>
	 <20071016130053.GA20010@srcf.ucam.org>
	 <20071016141153.GA3237@khazad-dum.debian.net>
	 <20071016142121.GA21431@srcf.ucam.org>
	 <20071016143124.GB3237@khazad-dum.debian.net>
	 <20071016144016.GA21749@srcf.ucam.org>
	 <20071016165623.GA13643@khazad-dum.debian.net>
	 <20071016184606.GB25181@srcf.ucam.org>
	 <alpine.LFD.0.999.0710161208340.6887@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > But it *is* a key press!
>
> To get somewhat back on track: volume and brightness (and similar - lid
> close etc) events clearly are keypresses.
>
> However, I would also argue that a keypress that is acted on by the
> firmware automatically is *different* from a keypress that hasn't been
> acted on: one is a "key was pressed *and* hardware did something
> automatically", and the other is just a "key was pressed" event.
>

We also have cases where userspace may have told ACPI to stop the
firmware acting on the keypress which may or may not be known to the
piece of the kernel dealing with keypresses... hence just pass the key
up to userspace and let it deal with it.

Dave.
