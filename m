Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbZDFBUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbZDFBUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 21:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbZDFBUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 21:20:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:49229 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZDFBUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 21:20:03 -0400
Subject: Re: Staging: sxg: Add support to download the firmware using
 request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mithlesh Thukral <mithlesh@linsyssoft.com>,
       Christopher Harrer <charrer@alacritech.com>
In-Reply-To: <20090406010754.GA32630@suse.de>
References: <200904051919.n35JJUUq031448@hera.kernel.org>
	 <1238978493.11870.2.camel@macbook.infradead.org>
	 <20090406010754.GA32630@suse.de>
Content-Type: text/plain
Date: Sun, 05 Apr 2009 18:19:55 -0700
Message-Id: <1238980795.11870.12.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-04-05 at 18:07 -0700, Greg KH wrote:
> Who do we email to add this to?

Clone git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git,
add your firmware (and update the WHENCE file accordingly), and send me
a pull request. Preferably with a Signed-off-by: from within the company
that owns the firmware in question.

> And finally, what's wrong with adding new firmware images into the
> firmware/ directory?  What is the issue here?

We're working on _removing_ this crap from the kernel source tree -- not
adding new instances of it. We have a separate repository in which we're
collecting redistributable firmware images, and the distributions are
moving towards shipping that instead of just the legacy stuff from the
kernel tree. Add any new firmware to that repository instead, as
described above.

-- 
dwmw2

