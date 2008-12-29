Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbYL2PCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbYL2PCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 10:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbYL2PCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 10:02:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41078 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbYL2PCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 10:02:41 -0500
Date: Mon, 29 Dec 2008 16:15:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, bfields@fieldses.org,
       xfs-masters@oss.sgi.com, Andi Kleen <andi@firstfloor.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [xfs-masters] RFC: Fix f_flags races without the BKL
Message-ID: <20081229151555.GG496@one.firstfloor.org>
References: <20081229041352.6bbdf57c@tpl> <20081229125050.GA22909@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229125050.GA22909@lst.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What speaks against having on in fs_struct so that it's at least not
> globally serialized?

That would not handle fds passed between processes?

-Andi

-- 
ak@linux.intel.com
