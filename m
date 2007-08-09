Return-Path: <linux-kernel-owner+w=401wt.eu-S938808AbXHIHZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938808AbXHIHZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 03:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764643AbXHIHZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 03:25:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48416 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762289AbXHIHZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 03:25:07 -0400
Message-ID: <46BAC14E.9040604@zytor.com>
Date: Thu, 09 Aug 2007 00:25:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Mikko Rapeli <mikko.rapeli@iki.fi>
CC: linux-kernel@vger.kernel.org
Subject: Re: early boot lockup with 2.6.23-rc1
References: <20070808223120.GA2286@nalle>
In-Reply-To: <20070808223120.GA2286@nalle>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikko Rapeli wrote:
> Hello,
> 
> Since 2.6.23-rc1 I can't boot an old k6 (with a funky IDE drive worth testing
> with libata). The boot hangs without a sound or letter prints on the
> screen right after grub, while 2.6.22.1 works fine.
> 

So it's not printing "Uncompressing kernel... " at all?

> Is my .config broken in ways I can't see, or is this perhaps regression?
> 

It might be an issue with the new setup code.  What happens if you
append "vga=ask" to the kernel command line?

	-hpa
