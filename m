Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbYCICq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbYCICq5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 21:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbYCICqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 21:46:47 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:31738 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbYCICqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 21:46:45 -0500
To: Christoph Hellwig <hch@lst.de>
Cc: Davide Libenzi <davidel@xmailserver.org>, linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH/RFC 1/2] anon-inodes: Remove fd_install() from anon_inode_getfd()
X-Message-Flag: Warning: May contain useful information
References: <20080225191043.GA32342@lst.de> <adak5kqyzv1.fsf@cisco.com>
	<Pine.LNX.4.64.0802271138170.377@alien.or.mcafeemobile.com>
	<adabq62yx5r.fsf@cisco.com>
	<Pine.LNX.4.64.0802271218210.377@alien.or.mcafeemobile.com>
	<ada7igqyurw.fsf@cisco.com> <adar6eyx8y5.fsf@cisco.com>
	<20080306151402.GA17077@lst.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Sat, 08 Mar 2008 18:46:39 -0800
In-Reply-To: <20080306151402.GA17077@lst.de> (Christoph Hellwig's message of "Thu, 6 Mar 2008 16:14:02 +0100")
Message-ID: <adazlt8r4vk.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Mar 2008 02:46:39.0566 (UTC) FILETIME=[CCC26EE0:01C8818F]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > No, the best interface is one where the driver doesn't even see
 > inode or file.  Of course that's not actually possible in a few
 > nasty cases like the infiniband code, and for those it might be
 > better to do the fd_isntall themselves.

Yeah, I've been thinking about this some more, and I think the IB case
can be cleaned up to use the current anonfd interface (and in fact
ignore the file pointer and inode it gets back).

I'll try to write a patch this week.

 - R.

