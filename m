Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbXIXLxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbXIXLxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 07:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535AbXIXLxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 07:53:07 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:33557 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533AbXIXLxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 07:53:06 -0400
Date: Mon, 24 Sep 2007 13:54:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jaswinder Singh <jaswinderlinux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22.7 default kernel configuration
Message-ID: <20070924115431.GA3150@uranus.ravnborg.org>
References: <3f9a31f40709240411u1cc56559o90dca73ce79abf5a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40709240411u1cc56559o90dca73ce79abf5a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 04:41:54PM +0530, Jaswinder Singh wrote:
> Hi all,
> 
> Can please someone let me know what is criteria for default kernel
> configuration .
> 
> Is it based upon some survey or requested by Fedora or others.
> 
> By default configuration size of vmlinux is 41 MB and it includes
> approx 75% of useless stuff for me.
> 
> what is the idea behind 'default kernel configuration'. Is it made for
> developers's PC  or for someone else.

For i386 it was in the past the .config Linus used for his PC.
There is nu deeper thoughts behind the i386 defconfig.
Other architectures try to let their defconfig cover a lot
because defconfig are often used for test-compiling
stuff (I for once use them a lot).

Other again just chose a popular config and use it for their defconfig.
So no fixed ruleset - and very depending on your architecture.

	Sam
