Return-Path: <linux-kernel-owner+w=401wt.eu-S1751677AbXDAXOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbXDAXOn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 19:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbXDAXOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 19:14:43 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:56870 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbXDAXOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 19:14:42 -0400
Date: Mon, 2 Apr 2007 09:14:40 +1000
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Powerpc build unhappy in 2.6.20.4?
Message-ID: <20070401231440.GK12768@bakeyournoodle.com>
Mail-Followup-To: Rob Landley <rob@landley.net>,
	linux-kernel@vger.kernel.org
References: <200703301753.27379.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703301753.27379.rob@landley.net>
User-Agent: Mutt/1.5.9i
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 05:53:26PM -0400, Rob Landley wrote:
> So doing:
> 
>   make ARCH=powerpc CROSS=powerpc-
> 
> Chugs along fine for a while, but then it ends with:
> 
>     MODPOST vmlinux

There should be a lot of activity between this step and the error below.

>   ln: accessing `arch/powerpc/boot/zImage': No such file or directory
>   make[1]: *** [arch/powerpc/boot/zImage] Error 1
>   make: *** [zImage] Error 2
> 
> I.E. it builds vmlinux, then dies because there's no zImage, which it never 
> tried to build...

zImage is built later, AFAICT
 
> Is there no working default "make" target for powerpc, or did I do something 
> wrong?  Could this be a .config issue?

Possibly, can we see your .config?

Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

