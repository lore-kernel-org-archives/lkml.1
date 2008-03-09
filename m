Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbYCICqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbYCICqD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 21:46:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbYCICpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 21:45:52 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:30284 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbYCICpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 21:45:51 -0500
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
Date: Sat, 08 Mar 2008 18:45:34 -0800
In-Reply-To: <20080306151402.GA17077@lst.de> (Christoph Hellwig's message of "Thu, 6 Mar 2008 16:14:02 +0100")
Message-ID: <ada4pbgsjht.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Mar 2008 02:45:34.0509 (UTC) FILETIME=[A5FB85D0:01C8818F]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >  	spin_lock(&kvm_lock);
 > +	if (--kvm->refcount) {
 > +		spin_lock(&kvm_lock);

obvious typo here...
