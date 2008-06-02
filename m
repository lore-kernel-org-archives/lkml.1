Return-Path: <linux-kernel-owner+w=401wt.eu-S1759828AbYFBLy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759828AbYFBLy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYFBLyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:54:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44765 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbYFBLyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:54:49 -0400
Date: Mon, 2 Jun 2008 12:41:53 +0100 (BST)
From: Alexey Korolev <akorolev@infradead.org>
To: Jared Hulbert <jaredeh@gmail.com>
cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] JFFS2 power loss recovery issues in 2.6.25, 2.6.26-rc
In-Reply-To: <6934efce0805301224t5e5d7a01n3b652c4df5324d58@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0806021239440.5100@pentafluge.infradead.org>
References: <alpine.LFD.1.10.0805291205480.22130@pentafluge.infradead.org> <6934efce0805301224t5e5d7a01n3b652c4df5324d58@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SRS-Rewrite: SMTP reverse-path rewritten from <akorolev@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> > We made some investigations for this issue and found commit number which
> > breaks JFFS2 power loss recoverability.
> > It is:  [JFFS2] Improve getdents vs. f_pos handling on NOR flash.
> >        http://git.infradead.org/mtd-2.6.git?a=commitdiff;h=15953580e79b58caefb107e77f218e009b9992e6
> >
> > Currently we don't know why it breaks JFFS2 and how it could be fixed
> > except roll back.
> 
> Does everything work when you unmerge this one commit?
> 
Correct, commit roll back fixes the problem. 

Thanks
Alexey
