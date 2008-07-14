Return-Path: <linux-kernel-owner+w=401wt.eu-S932136AbYGNXrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbYGNXrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 19:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759749AbYGNXrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 19:47:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43389 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759745AbYGNXrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 19:47:08 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080714164119.99c33d5b.akpm@linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 16:47:03 -0700
Message-Id: <1216079223.27455.92.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 16:41 -0700, Andrew Morton wrote:
> On Mon, 14 Jul 2008 16:23:26 -0700
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > Linus, please pull from the for-2.6.27 branch of:
> > 	git://git.infradead.org/users/dwmw2/firmware-2.6.git for-2.6.27
> 
> The firmware flamewars seem to have subsided lately.  Is everyone happy
> with this now?

I've deliberately left drivers/net out of this pull request... all
_other_ maintainers seemed quite happy to see their drivers updated to
use request_firmware().

Let's see how it pans out. I don't expect any problems -- after all,
modern drivers have been using request_firmware() for a _long_ time now,
and the distributions cope quite happily with it already. We're ready to
ship the firmware in a separate package in Fedora as soon as Linus pulls
from my tree. Once the dust has settled and it's all working fine, we
can look at converting drivers/net and drivers/scsi too.

-- 
dwmw2

