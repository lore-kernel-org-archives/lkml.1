Return-Path: <linux-kernel-owner+w=401wt.eu-S1761685AbXFDTOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761685AbXFDTOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761377AbXFDTNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:13:49 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:50592 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761528AbXFDTNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:13:48 -0400
Date: Mon, 4 Jun 2007 15:13:47 -0400
To: Mike Richards <mrmikerich@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Missing RAM on x86_64
Message-ID: <20070604191347.GE10008@csclub.uwaterloo.ca>
References: <516d7fa80706012151m32facb87nafb68811c784fa54@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516d7fa80706012151m32facb87nafb68811c784fa54@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2007 at 12:51:07AM -0400, Mike Richards wrote:
> Hi, I appear to be missing quite a bit of RAM on an x86_64 system. I
> have 1GB installed, but 'free' only shows 878MB:
> 
> pokey$ free -m
>             total       used       free     shared    buffers     cached
> Mem:           878        571        306          0         52        332
> -/+ buffers/cache:        186        691
> Swap:         1023          0       1023
> 
> I'm used to seeing a little bit of RAM missing with 32bit systems, but
> 146MB seems a bit much. The part of dmesg that concerns the RAM is
> shown below. Anyone know what's up here? Is this normal for an x86_64
> system?

I you running a 64 or 32bit kernel?  If it is 32bit then it is normal
for a kernel not configured with CONFIG_4GB or whatever it is called to
be limited to about 900MB ram.  64bit kernels should see all the ram no
matter what the config is.  It looks very much like you are running a
32bit kernel though.  What does uname -a say?

--
Len Sorensen
