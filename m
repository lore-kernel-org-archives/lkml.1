Return-Path: <linux-kernel-owner+w=401wt.eu-S965499AbXLTQ1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965499AbXLTQ1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 11:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932929AbXLTQ1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 11:27:06 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:55309 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965427AbXLTQ1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 11:27:04 -0500
Date: Thu, 20 Dec 2007 11:27:00 -0500
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Trying to convert old modules to newer kernels
Message-ID: <20071220162700.GF2308@csclub.uwaterloo.ca>
References: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com> <20071219202323.GH2310@csclub.uwaterloo.ca> <Pine.LNX.4.61.0712191555150.4514@chaos.analogic.com> <20071220150255.GE2308@csclub.uwaterloo.ca> <Pine.LNX.4.61.0712201107300.8261@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0712201107300.8261@chaos.analogic.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 11:13:19AM -0500, linux-os (Dick Johnson) wrote:
> It never gets to the printk(). You were right about the
> compilation. Somebody changed the kernel to compile with
> parameter passing in REGISTERS! This means that EVERYTHING
> needs to be compiled the same way, 'C' calling conventions
> were not good enough!
> 
> FYI, it has been previously shown that passing parameters
> in registers on register-starved ix86 machines is always
> a loss, because the registers need to be freed up, either
> by saving them on the stack or as dummy memory variables.
> 
> Now, they've done it to the entire kernel!

It's a config option.  I think redhat was the first to actually start
using it on their distributions.  Many distributions don't use it.
Debian does not use it on their kernels.

--
Len Sorensen
