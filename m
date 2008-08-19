Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbYHSTxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbYHSTxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYHSTwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:52:51 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:51694 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbYHSTwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:52:50 -0400
Date: Tue, 19 Aug 2008 21:52:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stuart Sheldon <stu@actusa.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: "make prepare" in 2.6.26.2 not behaving?
Message-ID: <20080819195228.GB6774@uranus.ravnborg.org>
References: <48AA4107.9090009@actusa.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AA4107.9090009@actusa.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 08:41:59PM -0700, Stuart Sheldon wrote:
> Hey all, think I found a little bug...
> 
> I recently was attempting to build 3rd party modules on a 2.6.26.2 
> source tree after a "make clean" was run on the kernel source tree.
> 
> In the past I would run "make oldconfig prepare scripts" and then build 
> and install the 3rd party module. All would work as expected.
> 
> And all started well with the 2.6.26.2 tree. The module built without 
> error, but when I went to load it, it responded back with a version 
> error on the console, and the dmesg was: "no symbol version for 
> struct_module".
> 
> If I rebuild the entire kernel and modules in the source tree and then 
> build the 3rd party module again, It builds and loads without issue.
> 
> I'm hoping this is a bug, as I use the prepare method of setting up 
> source trees a lot. It saves me hours of time on my server farm.

If you have MODULE_VERSIONING enabled then you need to build
the kernel - "make prepare" is in that case not enough.

Ig you have module.symvers around then that will do it.

	Sam

