Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbYCQKl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbYCQKl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 06:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYCQKlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 06:41:18 -0400
Received: from verein.lst.de ([213.95.11.210]:52432 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbYCQKlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 06:41:18 -0400
Date: Mon, 17 Mar 2008 11:40:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: Roland Dreier <rdreier@cisco.com>
Cc: Christoph Hellwig <hch@lst.de>, Davide Libenzi <davidel@xmailserver.org>,
       linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH/RFC 1/2] anon-inodes: Remove fd_install() from anon_inode_getfd()
Message-ID: <20080317104025.GA9663@lst.de>
References: <20080225191043.GA32342@lst.de> <adak5kqyzv1.fsf@cisco.com> <Pine.LNX.4.64.0802271138170.377@alien.or.mcafeemobile.com> <adabq62yx5r.fsf@cisco.com> <Pine.LNX.4.64.0802271218210.377@alien.or.mcafeemobile.com> <ada7igqyurw.fsf@cisco.com> <adar6eyx8y5.fsf@cisco.com> <20080306151402.GA17077@lst.de> <ada4pbgsjht.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada4pbgsjht.fsf@cisco.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2008 at 06:45:34PM -0800, Roland Dreier wrote:
>  >  	spin_lock(&kvm_lock);
>  > +	if (--kvm->refcount) {
>  > +		spin_lock(&kvm_lock);
> 
> obvious typo here...

Indeed.  Any comments from the kvm developers in this approach?  The
current multi-level file refcounting seems rather bogus so I'd like
to make some progress on this.

