Return-Path: <linux-kernel-owner+w=401wt.eu-S1759355AbYGPWms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355AbYGPWms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 18:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYGPWmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 18:42:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56210 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYGPWmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 18:42:39 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
In-Reply-To: <200807162328.37754.rjw@sisk.pl>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <1216154956.26991.30.camel@shinybook.infradead.org>
	 <1216191718.30898.16.camel@shinybook.infradead.org>
	 <200807162328.37754.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 15:42:32 -0700
Message-Id: <1216248152.1862.21.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-16 at 23:28 +0200, Rafael J. Wysocki wrote:
> On Wednesday, 16 of July 2008, David Woodhouse wrote:
> > On Tue, 2008-07-15 at 13:49 -0700, David Woodhouse wrote:
> > > I need to hassle Sam about that.
> > 
> > I think I have it. Rafael, does _this_ fix it for you?
> 
> No, but the error message seems to be different:
> 
>   HOSTCC  firmware/ihex2fw
> /home/rafael/src/linux-next/firmware/ihex2fw.c:268: fatal error: opening dependency file firmware/.ihex2fw.d: Read-only file system
> compilation terminated.

Hm, can you do that again with V=2?

> Removing the FORCE from line 117 of scripts/Makefile.host makes it work.
> 
> Of course, I still have to run "make ... firmware_install" locally on the
> server.

Yeah, that part is easy enough to fix, once the unwanted rebuilding is
fixed.

-- 
dwmw2

