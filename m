Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbXF2U7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbXF2U7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 16:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbXF2U7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 16:59:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56357 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754477AbXF2U7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 16:59:02 -0400
Date: Fri, 29 Jun 2007 13:58:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1
Message-Id: <20070629135847.70f1113b.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706291613040.1818@scrub.home>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706291613040.1818@scrub.home>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007 16:17:38 +0200 (CEST)
Roman Zippel <zippel@linux-m68k.org> wrote:

> On Thu, 28 Jun 2007, Andrew Morton wrote:
> 
> >   So save yourself some hassle and check your .config carefully before
> >   building this kernel.  Make sure that everything you need is still enabled.
> > 
> >   I found that manually adding "CONFIG_BLK_DEV=y" to the .config before
> >   running oldconfig saved a large number of config items from getting lost.
> 
> This patch should help for this, so that this isn't done when Kconfig or 
> .config has been changed and they are not in sync.
> 
> bye, Roman
> 
> 
> Reset generates values only if Kconfig and .config agree.

unclear.  Could you please explain further what this change does?

Thanks.
