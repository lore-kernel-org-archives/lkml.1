Return-Path: <linux-kernel-owner+w=401wt.eu-S932807AbXBVIEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807AbXBVIEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945952AbXBVIEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:04:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37581 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862AbXBVIEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:04:48 -0500
Subject: Re: -freg-struct-return?
From: Arjan van de Ven <arjan@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <45DCF1C5.4030006@goop.org>
References: <45DCF1C5.4030006@goop.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 22 Feb 2007 09:04:23 +0100
Message-Id: <1172131463.3531.226.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 17:28 -0800, Jeremy Fitzhardinge wrote:
> We have a number of functions which return small structures (such as
> pte_t).  It seems that the kernel is not compiled with
> -freg-struct-return, so all these small structures are being returned
> via the stack, even though they would fit into registers.
> 
> Is there a reason for this?  Would -freg-struct-return be preferred?  It
> would make a good compliment to -mregparm.

Do we know how many gcc bugs this has? (regparm used to have many)
other than that.. sounds like a win...

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

