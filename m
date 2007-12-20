Return-Path: <linux-kernel-owner+w=401wt.eu-S934393AbXLTS0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934393AbXLTS0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 13:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759073AbXLTS03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 13:26:29 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:48970 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbXLTS02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 13:26:28 -0500
Date: Thu, 20 Dec 2007 19:28:15 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Trying to convert old modules to newer kernels
Message-ID: <20071220182815.GA5438@uranus.ravnborg.org>
References: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com> <20071219202323.GH2310@csclub.uwaterloo.ca> <Pine.LNX.4.61.0712191555150.4514@chaos.analogic.com> <20071220150255.GE2308@csclub.uwaterloo.ca> <Pine.LNX.4.61.0712201107300.8261@chaos.analogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0712201107300.8261@chaos.analogic.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> It never gets to the printk(). You were right about the
> compilation. Somebody changed the kernel to compile with
> parameter passing in REGISTERS! This means that EVERYTHING
> needs to be compiled the same way, 'C' calling conventions
> were not good enough!

How did you build the module. It reads like you failed to use
kbuild to build your module which is why you did not pass
correct options to gcc - correct?

If you did not use kbuild - why not?
Is there anything missing you need?

	Sam
