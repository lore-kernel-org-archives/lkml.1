Return-Path: <linux-kernel-owner+w=401wt.eu-S933154AbXCELJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbXCELJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 06:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933168AbXCELJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 06:09:54 -0500
Received: from nz-out-0506.google.com ([64.233.162.235]:19997 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933144AbXCELJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 06:09:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JLbqIM6KCkAp+5Vn0UTF+uyJyVVqmZ1mict1i5S5vskdci6EvDnbsDLTokFoaljAkin24EimPOs8e2aCUeeB729AN6ihAQNcWqKnThNFeadLpq21qpiT4H2Zxkm4mHx3OaGyzm8CwqqMR21OAhY/KDwSzbhWxFTaZY2KPMqtjSc=
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: fsync() method for deferred
	I/O flush.
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: Andrew Morton <akpm@linux-foundation.org>, jayakumar.lkml@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070305103905.GA12601@linux-sh.org>
References: <20070305103905.GA12601@linux-sh.org>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 19:11:48 +0800
Message-Id: <1173093108.6782.15.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 19:39 +0900, Paul Mundt wrote:
> There are cases when we do not want to wait on the delay for
> automatically updating the "real" framebuffer, this implements a
> simple ->fsync() hook for explicitly flushing the deferred I/O
> work. The ->page_mkwrite() handler will rearm the work queue
> normally.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Antonino Daplas <adaplas@gmail.com>

Tony

