Return-Path: <linux-kernel-owner+w=401wt.eu-S1764325AbXJXQ5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764325AbXJXQ5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762160AbXJXQlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:41:20 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:59585 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763472AbXJXQlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:41:18 -0400
Subject: Re: [RFC: 2.6 patch] nsp32_restart_autoscsi(): remove error check
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: yokota@netlab.is.tsukuba.ac.jp, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071024162515.GV30533@stusta.de>
References: <20071024162515.GV30533@stusta.de>
Content-Type: text/plain
Date: Wed, 24 Oct 2007 12:41:12 -0400
Message-Id: <1193244072.3396.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-24 at 18:25 +0200, Adrian Bunk wrote:
> The Coverity checker noted that we'll anyway Oops later when we ran into 
> this condition - and the error check didn't prevent that.
> 
> Considering that the error condition shouldn't be possible, and we are 
> not able to handle it easily, this patch simply removes the pointless 
> error check.

This is the one where I said I don't like the fact that you're removing
the explanatory message that's printed before we crash.  if you want to
shut coverity up and stop sending the patch, I'm happy adding a BUG();
after the nsp32_msg().

James


