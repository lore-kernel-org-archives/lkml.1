Return-Path: <linux-kernel-owner+w=401wt.eu-S1763643AbYEFNK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763643AbYEFNK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 09:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757240AbYEFNKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 09:10:34 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:35634 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762503AbYEFNKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 09:10:33 -0400
Message-ID: <482058C4.8010104@davidnewall.com>
Date: Tue, 06 May 2008 22:40:28 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: Ulrich Drepper <drepper@redhat.com>, bsn.0007@gmail.com,
       libc-alpha@sourceware.org, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Christoph Hellwig <hch@lst.de>, Mingming Cao <cmm@us.ibm.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 1/2] Union Mount: glibc readdir support
References: <20080429133201.GA9938@localhost.localdomain> <20080429133346.GB9938@localhost.localdomain> <48195E69.3030701@redhat.com> <20080506042117.GA29298@in.ibm.com>
In-Reply-To: <20080506042117.GA29298@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bharata B Rao wrote:
> Is dis-allowing NFS-exporting of unions an option ?

Is it that simple?  What about a union further in an NFS export?  What
about union-mounting after the tree has been NFS-exported?  If the
kernel won't fully merge unions then FS servers have to do whatever it
is that's being proposed for glibc.
