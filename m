Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbZASPgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbZASPgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 10:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZASPfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 10:35:50 -0500
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:63251 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbZASPft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 10:35:49 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [Ecryptfs-devel] [PATCH] ecryptfs: some inode attrs, and a question 
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
In-Reply-To: <1232379004.5893.7.camel@norville.austin.ibm.com>
References: <7471.1231827621@jrobl> <1231852628.6954.4.camel@norville.austin.ibm.com> <496FAFE2.8020102@linux.vnet.ibm.com> <9829.1232091366@jrobl> <1232125169.15209.19.camel@norville.austin.ibm.com> <7210.1232172192@jrobl> <1232210546.7015.8.camel@norville.austin.ibm.com> <10394.1232214142@jrobl> <1232215916.7015.78.camel@norville.austin.ibm.com> <7087.1232331454@jrobl> <1232377295.5893.1.camel@norville.austin.ibm.com> <11994.1232378730@jrobl> <1232379004.5893.7.camel@norville.austin.ibm.com>
Date: Tue, 20 Jan 2009 00:35:43 +0900
Message-ID: <12188.1232379343@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dave Kleikamp:
> > Does "ecryptfs_interpose() will overwrite the correct upper inode size"
> > means ecryptfs_interpose() sets a wrong value?
> 
> Yes.  ecryptfs_interpose() will copy the lower inode's size to the upper
> inode.  For an encrypted file, the lower inode will have a larger size,
> since the lower file is prefixed with a header.

I see.
I am afraid my poor English made me misunderstood.
Thank you.


J. R. Okajima
