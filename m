Return-Path: <linux-kernel-owner+w=401wt.eu-S1030464AbXBAAgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030464AbXBAAgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 19:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030471AbXBAAgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 19:36:50 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33135 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030464AbXBAAgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 19:36:50 -0500
Date: Wed, 31 Jan 2007 16:36:38 -0800
From: Andrew Morton <akpm@osdl.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.20-rc6-mm3
Message-Id: <20070131163638.290f40c1.akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0701311626160.12104@schroedinger.engr.sgi.com>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	<Pine.LNX.4.64.0701311559310.11853@schroedinger.engr.sgi.com>
	<20070131162422.6bccc52c.akpm@osdl.org>
	<Pine.LNX.4.64.0701311626160.12104@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007 16:27:16 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 31 Jan 2007, Andrew Morton wrote:
> 
> > ow.  Please don't make me drop git-block-and-lots-of-other-things again.
> > Was 2.6.20-rc6-mm2 OK?  It didn't have git-block.
> 
> Yes, 2.6.20-rc6-mm2 was okay. Sorry.

OK, thanks.

Actually, we might not have lost an IO: it could be that we're simply
missing an unplug.  Are you able to unblock things by forcing some other IO
against that queue?  Say, do a read from /dev/sda?

