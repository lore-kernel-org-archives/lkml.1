Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbZASPZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbZASPZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 10:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZASPZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 10:25:37 -0500
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:63023 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbZASPZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 10:25:37 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [Ecryptfs-devel] [PATCH] ecryptfs: some inode attrs, and a question 
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
In-Reply-To: <1232377295.5893.1.camel@norville.austin.ibm.com>
References: <7471.1231827621@jrobl> <1231852628.6954.4.camel@norville.austin.ibm.com> <496FAFE2.8020102@linux.vnet.ibm.com> <9829.1232091366@jrobl> <1232125169.15209.19.camel@norville.austin.ibm.com> <7210.1232172192@jrobl> <1232210546.7015.8.camel@norville.austin.ibm.com> <10394.1232214142@jrobl> <1232215916.7015.78.camel@norville.austin.ibm.com> <7087.1232331454@jrobl> <1232377295.5893.1.camel@norville.austin.ibm.com>
Date: Tue, 20 Jan 2009 00:25:30 +0900
Message-ID: <11994.1232378730@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dave Kleikamp:
> > > For a regular file, the size of the upper inode is not the same as the
> > > size of the lower inode.  The lower inode includes the header blocks
> > > which are not visible in the upper inode.  So ecryptfs_interpose() will
> > > overwrite the correct upper inode size.
	:::
> It's restoring i_size to the correct value after ecryptfs_interpose
> updates it with the wrong value.

Does "ecryptfs_interpose() will overwrite the correct upper inode size"
means ecryptfs_interpose() sets a wrong value?
If so, I can understand why ecryptfs_link() sets i_size.


J. R. Okajima
