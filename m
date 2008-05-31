Return-Path: <linux-kernel-owner+w=401wt.eu-S1762192AbYFEWWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762192AbYFEWWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 18:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYFEWWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 18:22:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44858 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbYFEWWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 18:22:10 -0400
Subject: Re: [PATCH 10/18] ihex.h: binary representation of ihex records
From: David Woodhouse <dwmw2@infradead.org>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4847DB82.60408@ladisch.de>
References: <20080605.foo@pmac.infradead.org>
	 <E1K4C9q-0001dA-5i@bombadil.infradead.org>  <4847DB82.60408@ladisch.de>
Content-Type: text/plain
Date: Sat, 31 May 2008 23:20:51 +0100
Message-Id: <1212272451.2534.29.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 14:26 +0200, Clemens Ladisch wrote:
> 
> David Woodhouse wrote:
> > Some devices need their firmware as a set of {address, len, data...}
> > records in some specific order rather than a simple blob.
> 
> At least in the case of EZ-USB-based devices, this is not a requirement.
> It seems most tools just do not bother to order the records in Intel hex
> files.  Any firmware that is downloaded with the EZ-USB's "load
> internal" request (0xa0) can be converted to a plain memory dump.

Hm, in that case it might be worth converting this stuff into raw
binaries. I'm not in a position to test, and wanted to keep my own
changes as unintrusive as possible though.

-- 
dwmw2

