Return-Path: <linux-kernel-owner+w=401wt.eu-S966020AbXDHBmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966020AbXDHBmx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 21:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966039AbXDHBmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 21:42:53 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:37908 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966020AbXDHBmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 21:42:52 -0400
Date: Sat, 7 Apr 2007 21:42:50 -0400
To: johnrobertbanks@fastmail.fm
Cc: Valdis.Kletnieks@vt.edu, Ignatich <ignatich@gmail.com>,
       reiserfs-list@namesys.com, linux-kernel@vger.kernel.org
Subject: Re: COMPILING AND CONFIGURING A NEW KERNEL.
Message-ID: <20070408014250.GH3510@csclub.uwaterloo.ca>
References: <46157B5B.5000602@gmail.com> <1175817921.18400.1183285196@webmail.messagingengine.com> <1175909205.905.1183425104@webmail.messagingengine.com> <12252.1175964174@turing-police.cc.vt.edu> <1175994157.1894.1183513166@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175994157.1894.1183513166@webmail.messagingengine.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2007 at 06:02:37PM -0700, johnrobertbanks@fastmail.fm wrote:
> Thats interesting, I didn't know that. 
> 
> Do you know if deb-pkg and rpm-pkg take care of creating the initrd
> automatically.
> 
> I seriously doubt they do.
> 
> Actually, I guess I only need to compile another kernel to find out.

Certainly on debian make-kpkg actually does have options for initrd
(--initrd) and will call mkinitrd/update-initramfs/yaird at package
install time to generate an initrd for the kernel to deal with raid,
lvm, etc.  It works quite well in general.

I would be surprised if redhat didn't do something similar.

--
Len Sorensen
