Return-Path: <linux-kernel-owner+w=401wt.eu-S932427AbYEUSnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427AbYEUSnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756541AbYEUSnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:43:42 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:38450 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbYEUSnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:43:41 -0400
Date: Wed, 21 May 2008 19:41:47 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: werner <werner@sys-linux.yi.org>
cc: Chas Williams <chas@cmf.nrl.navy.mil>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rcX: Problem with mem config > 4GB ; fore2000 atm driver
 options
In-Reply-To: <1211312990.4898@sys-linux.yi.org>
Message-ID: <Pine.LNX.4.64.0805211930520.20306@blonde.site>
References: <1211312990.4898@sys-linux.yi.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008, werner wrote:
> I observed the following problems with 2.6.26-rcX-gitY:
> 
> Steady-steady I got segmentation faults. On 2.6.25.4 no problems.  I compiled plenty times the newer kernels to find out the reason.   I thing the problem is the memory configuration as > 4 GB.  In my config file, since earlier kernels, i configured >4 GB. When I use  config files with that, then occure the problems, with <4 GB not. It seems that the menuconfig of the new kernels accept only until 4 GB.

It's worth now trying 2.6.26-rc3-git2 or later: there was indeed a
problem introduced in 2.6.26-rc2-git<I-haven't-looked-which> which
caused segfaults in various things when CONFIG_HIGHMEM64G.

(See http://lkml.org/lkml/2008/5/19/446 for what I'm talking about;
but Linus put in Jeremy's proper fixes instead of that brief hack.)

> 
> Another problem with the fore2000 atm configuration. When one affirms the default config of menuconfig, then the compilation crashs because it wouldn't find the path of these drivers. When one explicitely click  x  , affirming the default path (what would be default anyway) then the compilation works.   This seems to be an error of the menuconfig and should be corrected

Sorry, I've not looked into that at all: Cc'ed ATM maintainer.

Hugh
