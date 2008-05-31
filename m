Return-Path: <linux-kernel-owner+w=401wt.eu-S1763169AbYFEWqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763169AbYFEWqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 18:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbYFEWqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 18:46:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60617 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYFEWqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 18:46:30 -0400
Subject: Re: [PATCH 00/18] firmware: moving drivers to request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48486B05.30300@garzik.org>
References: <20080605.foo@pmac.infradead.org>  <4848648D.8010501@garzik.org>
	 <1212272337.2534.27.camel@shinybook.infradead.org>
	 <48486B05.30300@garzik.org>
Content-Type: text/plain
Date: Sat, 31 May 2008 23:45:14 +0100
Message-Id: <1212273914.2534.35.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 18:39 -0400, Jeff Garzik wrote:
> IMO, if-and-only-if you are touching driver firmwares, you should not do 
> anything but render them into their preferred form.
> 
> It is useless churn that increases maintenance annoyances to convert an 
> in-tree firmware to something other than the form it's in now, so you 
> might as well get it right.

I believe that making that change would cause extra controversy that I
don't need, and make it harder for me to get what I _actually_ care
about merged -- which is the basic conversion to request_firmware().

But as I said, if _you_ want to start converting drivers and posting
patches which add raw binary blobs in the firmware/ directory, please
feel free. If they go in without comment, I'll be happy to admit that I
was wrong and start doing raw binaries in future.

-- 
dwmw2

