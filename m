Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbYFBT75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbYFBT75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 15:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbYFBT7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 15:59:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55656 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbYFBT7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 15:59:48 -0400
Subject: Re: v4l regression: V4L2_CID_[VH]CENTER disappeared without notice.
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Brandon Philips <bphilips@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Bastien Nocera <bnocera@redhat.com>
In-Reply-To: <20080602201911.1a48cc83@core>
References: <200804241931.m3OJVQiR022368@hera.kernel.org>
	 <1212421611.16924.246.camel@pmac.infradead.org>
	 <20080602165649.01c2c680@core>
	 <1212434648.8810.10.camel@shinybook.infradead.org>
	 <20080602201911.1a48cc83@core>
Content-Type: text/plain
Date: Mon, 02 Jun 2008 20:59:38 +0100
Message-Id: <1212436778.8810.27.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-02 at 20:19 +0100, Alan Cox wrote:
> > Don't forget to document how people are _supposed_ to use the v4l api
> > from userspace, though.
> 
> Correct but those methods are not part of the V4L2 API and have not been
> for some considerable time. 

It seems that message hadn't got through. Any suggestions as to how we
could make sure it does in future?

The usual answers are (in order of preference):
 1) don't remove userspace APIs
 2) don't remove userspace APIs
 3) Documentation/feature-removal-schedule.txt
 4) don't remove userspace APIs

It would be good if we could combine #3 with some form of
__deprecated... can we make that work for ioctls in userspace?

-- 
dwmw2

