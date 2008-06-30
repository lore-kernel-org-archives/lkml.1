Return-Path: <linux-kernel-owner+w=401wt.eu-S932783AbYF3NWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbYF3NWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932165AbYF3NVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:21:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48191 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132AbYF3NVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:21:16 -0400
Subject: Re: [Linux-ATM-General] [PATCH] firmware: convert Ambassador ATM
	driver to request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: "Chas Williams (CONTRACTOR)" <chas@cmf.nrl.navy.mil>
Cc: netdev@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <200806301315.m5UDFc0E022495@cmf.nrl.navy.mil>
References: <200806301315.m5UDFc0E022495@cmf.nrl.navy.mil>
Content-Type: text/plain
Date: Mon, 30 Jun 2008 14:21:12 +0100
Message-Id: <1214832072.10393.342.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-30 at 09:15 -0400, Chas Williams (CONTRACTOR) wrote:
> In message <1214831362.10393.340.camel@pmac.infradead.org>,David Woodhouse writ
> es:
> >And wasn't it sba200e_ecd.bin ? 
> 
> oops.  sparc is big endian.  adding the const we have...

You probably still want the ifdefs for MODULE_FIRMWARE().

-- 
dwmw2

