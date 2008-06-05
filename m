Return-Path: <linux-kernel-owner+w=401wt.eu-S1761963AbYFES22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761963AbYFES22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbYFES2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:28:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48867 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbYFES2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:28:15 -0400
Subject: Re: [PATCH] firmware: convert Ambassador ATM driver to
	request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: chas3@users.sourceforge.net
Cc: Giuliano Procida <gprocida@marge.com>,
       linux-atm-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <200806051820.m55IKqp0031852@cmf.nrl.navy.mil>
References: <200806051820.m55IKqp0031852@cmf.nrl.navy.mil>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 19:28:09 +0100
Message-Id: <1212690489.32207.285.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 14:20 -0400, Chas Williams (CONTRACTOR) wrote:
> it would need to be converted to the binary form first, or the patch
> will need to rewritten to use the s-record format.

We can do binary form. We just run it through objcopy -Ibinary -Oihex
for convenience of handling it (and that's different to the ones we
actually hand to the kernel in the form of records).

-- 
dwmw2

