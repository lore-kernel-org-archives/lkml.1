Return-Path: <linux-kernel-owner+w=401wt.eu-S1767026AbXDEOsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767026AbXDEOsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767016AbXDEOsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:48:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41296 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767024AbXDEOsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:48:01 -0400
Subject: Re: [PATCH v3] Stop pmac_zilog from abusing 8250's device numbers;
	optionally.
From: David Woodhouse <dwmw2@infradead.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, Torben Mathiasen <torben@kernel.org>
Cc: paulus@samba.org, alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       device@lanana.org
In-Reply-To: <20070405.233101.106261123.anemo@mba.ocn.ne.jp>
References: <1175666635.2932.17.camel@shinybook.infradead.org>
	 <17939.17962.248566.886449@cargo.ozlabs.ibm.com>
	 <1175696383.2774.24.camel@shinybook.infradead.org>
	 <20070405.233101.106261123.anemo@mba.ocn.ne.jp>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 10:47:15 -0400
Message-Id: <1175784435.2719.18.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-7.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 23:31 +0900, Atsushi Nemoto wrote
> Is major 204 minor 192 already allocated?

Of course. The reason it took so long to provide this patch after the
'pmac_zilog doesn't load' bug got reported was because I was waiting for
the new allocation.

> Few weeks ago, I sent a patch to allocate 192...199 for other serial
> driver 

Were those numbers assigned to you or did you just make them up?

-- 
dwmw2

