Return-Path: <linux-kernel-owner+w=401wt.eu-S1759470AbZABS3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbZABS3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758507AbZABS3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:29:15 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45198 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812AbZABS3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:29:14 -0500
Date: Fri, 2 Jan 2009 18:29:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@lst.de>, Jonathan Corbet <corbet@lwn.net>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       bfields@fieldses.org, xfs-masters@oss.sgi.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [xfs-masters] RFC: Fix f_flags races without the BKL
Message-ID: <20090102182911.GG28946@ZenIV.linux.org.uk>
References: <20081229041352.6bbdf57c@tpl> <20081229125050.GA22909@lst.de> <20081229151555.GG496@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229151555.GG496@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 04:15:55PM +0100, Andi Kleen wrote:
> > What speaks against having on in fs_struct so that it's at least not
> > globally serialized?
> 
> That would not handle fds passed between processes?

Doesn't need to be passed; just inherited from common ancestor...
