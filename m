Return-Path: <linux-kernel-owner+w=401wt.eu-S933577AbZDIKaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577AbZDIKaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933693AbZDIK3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:29:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53170 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933663AbZDIK3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:29:15 -0400
Date: Thu, 9 Apr 2009 07:28:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: linux-media@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Next April 9 : x86 allmodconfig media/video/cx88 build break
Message-ID: <20090409072854.3ed8a3bd@pedra.chehab.org>
In-Reply-To: <49DDC93B.8020106@in.ibm.com>
References: <20090409163305.8c7a0371.sfr@canb.auug.org.au>
	<49DDC93B.8020106@in.ibm.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Apr 2009 15:38:59 +0530
Sachin Sant <sachinp@in.ibm.com> wrote:

> Today's Next tree allmodconfig build on x86 failed with
> 
> ERROR: __divdi3 [drivers/media/video/cx88/cx88xx.ko] undefined!
> 
> Thanks
> -Sachin
> 
Hi Sachin,

Thanks for warning about this. This error happens only with some gcc versions.
Yet, I'm adding a patch to use do_div() to avoid such troubles. It should be
there for today's linux-next.

Cheers,
Mauro
