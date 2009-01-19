Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992AbZASPaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbZASPaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 10:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZASPaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 10:30:08 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33692 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZASPaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 10:30:06 -0500
Subject: Re: [Ecryptfs-devel] [PATCH] ecryptfs: some inode attrs, and a
 question
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: hooanon05@yahoo.co.jp
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
In-Reply-To: <11994.1232378730@jrobl>
References: <7471.1231827621@jrobl>
	 <1231852628.6954.4.camel@norville.austin.ibm.com>
	 <496FAFE2.8020102@linux.vnet.ibm.com> <9829.1232091366@jrobl>
	 <1232125169.15209.19.camel@norville.austin.ibm.com> <7210.1232172192@jrobl>
	 <1232210546.7015.8.camel@norville.austin.ibm.com> <10394.1232214142@jrobl>
	 <1232215916.7015.78.camel@norville.austin.ibm.com> <7087.1232331454@jrobl>
	 <1232377295.5893.1.camel@norville.austin.ibm.com>  <11994.1232378730@jrobl>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 09:30:04 -0600
Message-Id: <1232379004.5893.7.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 00:25 +0900, hooanon05@yahoo.co.jp wrote:
> Dave Kleikamp:
> > > > For a regular file, the size of the upper inode is not the same as the
> > > > size of the lower inode.  The lower inode includes the header blocks
> > > > which are not visible in the upper inode.  So ecryptfs_interpose() will
> > > > overwrite the correct upper inode size.
> 	:::
> > It's restoring i_size to the correct value after ecryptfs_interpose
> > updates it with the wrong value.
> 
> Does "ecryptfs_interpose() will overwrite the correct upper inode size"
> means ecryptfs_interpose() sets a wrong value?

Yes.  ecryptfs_interpose() will copy the lower inode's size to the upper
inode.  For an encrypted file, the lower inode will have a larger size,
since the lower file is prefixed with a header.

> If so, I can understand why ecryptfs_link() sets i_size.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

