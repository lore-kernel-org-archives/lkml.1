Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbYFBTY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbYFBTY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 15:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYFBTYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 15:24:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53880 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbYFBTYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 15:24:14 -0400
Subject: Re: v4l regression: V4L2_CID_[VH]CENTER disappeared without notice.
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Brandon Philips <bphilips@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Bastien Nocera <bnocera@redhat.com>
In-Reply-To: <20080602165649.01c2c680@core>
References: <200804241931.m3OJVQiR022368@hera.kernel.org>
	 <1212421611.16924.246.camel@pmac.infradead.org>
	 <20080602165649.01c2c680@core>
Content-Type: text/plain
Date: Mon, 02 Jun 2008 20:24:08 +0100
Message-Id: <1212434648.8810.10.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-02 at 16:56 +0100, Alan Cox wrote:
> (See 'do not include kernel headers in user space apps')

We don't just hide behind that statement any more.

If you _mean_ it that <linux/videodev2.h> is not intended for userspace
usage, then submit a patch to remove it from the Kbuild file so that it
no longer gets exported.

Don't forget to document how people are _supposed_ to use the v4l api
from userspace, though.

-- 
dwmw2

