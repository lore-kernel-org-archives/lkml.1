Return-Path: <linux-kernel-owner+w=401wt.eu-S1761433AbYFEUxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433AbYFEUxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 16:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbYFEUxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 16:53:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37078 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbYFEUxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 16:53:14 -0400
Subject: Re: [PATCH 00/18] firmware: moving drivers to request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4848489C.6010903@garzik.org>
References: <20080605.foo@pmac.infradead.org>  <48483BA9.1070200@garzik.org>
	 <1212695675.32207.288.camel@pmac.infradead.org>
	 <4848489C.6010903@garzik.org>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 21:53:10 +0100
Message-Id: <1212699190.32207.293.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 16:12 -0400, Jeff Garzik wrote:
> Well, I should ask, is this purely an internal build detail?
>
> The developer (and user) should never ever see a .ihex file, outside of 
> an active kernel compile.  Wrapping the original firmware makes it more 
> difficult to verify, compare and/or change.  In-tree, we should see the 
> vendor firmware blobs as shipped, with no wrapping or modification or 
> anything.

It's a build-and-shipping detail, at least in the kernel source tree.

Rather than putting binary blobs into git (which admittedly we could,
but it's suboptimal), we just run them through 'objcopy -Oihex' first.

It's not 'wrapped'; it's not any more difficult to verify, compare or
change.

-- 
dwmw2

