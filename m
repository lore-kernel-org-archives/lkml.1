Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbZBQL2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbZBQL2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 06:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZBQL2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 06:28:11 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51340 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZBQL2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 06:28:10 -0500
Subject: Re: [PATCH mmotm 6/6] nilfs2: replace BUG_ON and BUG calls
	triggerable from ioctl
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1234856526-1947-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1234856526-1947-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	 <1234856526-1947-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Date: Tue, 17 Feb 2009 13:28:08 +0200
Message-Id: <1234870088.21383.3.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 16:42 +0900, Ryusuke Konishi wrote:
> Pekka Enberg advised me:
> > It would be nice if BUG(), BUG_ON(), and panic() calls would be
> > converted to proper error handling using WARN_ON() calls. The BUG()
> > call in nilfs_cpfile_delete_checkpoints(), for example, looks to be
> > triggerable from user-space via the ioctl() system call.
> 
> This will follow the comment and keep them to a minimum.
> 
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Looks good to me!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

