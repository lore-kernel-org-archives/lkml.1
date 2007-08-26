Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbXHZWu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbXHZWu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 18:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbXHZWuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 18:50:20 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:16010 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbXHZWuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 18:50:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NOe3SY4fu7xv/WAake8ybkSjCVK+/M2WvW2IrqViK2VfbYnfY2HKSU89lfVW/yBvIeO9KP5JAhR8/45jE+l5b9HZ+UcUW194nfgYIrkk9itHNXDtgghgA5HeCEsfzB0NpPnOecsNZzJkiKNTAzXtg5oV+8TWm+SrFdt+qRm3hlo=
Subject: Re: [Linux-fbdev-devel] [PATCH] fbdev: find mode with highest
	refresh rate in fb_find_mode()
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: spock@gentoo.org
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ondrej Zajicek <santiago@crfreenet.org>
In-Reply-To: <20070826190913.GA24286@spock.one.pl>
References: <20070718084102.GA22694@spock.one.pl>
	 <20070718143803.GA5787@localhost.localdomain>
	 <1184771895.4523.33.camel@daplas>  <20070826190913.GA24286@spock.one.pl>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 06:49:33 +0800
Message-Id: <1188168573.4806.5.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-26 at 21:09 +0200, Michal Januszewski wrote:
> On Wed, Jul 18, 2007 at 11:18:15PM +0800, Antonino A. Daplas wrote:
> 
> How about modifying it so that it looks for a mode with the highest
> refresh rate if either a non-generic modedb is used or
> info.monspecs.{vfmin,vfmax,hfmin,hfmax,dclkmax} are all non-zero,
> and for a mode with refresh rate closest to 60 Hz otherwise?

I would opt for combining the two, return the highest refresh rate only
if the modedb was built by the driver and with the mode checked against
the display's operating limits.

Tony


