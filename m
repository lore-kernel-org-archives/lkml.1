Return-Path: <linux-kernel-owner+w=401wt.eu-S1767031AbXDEPJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767031AbXDEPJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 11:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767033AbXDEPJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 11:09:21 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:50780 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767023AbXDEPJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 11:09:20 -0400
Date: Fri, 06 Apr 2007 00:09:13 +0900 (JST)
Message-Id: <20070406.000913.28784231.anemo@mba.ocn.ne.jp>
To: dwmw2@infradead.org
Cc: torben@kernel.org, paulus@samba.org, alan@lxorguk.ukuu.org.uk,
       flar@allandria.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, device@lanana.org
Subject: Re: [PATCH v3] Stop pmac_zilog from abusing 8250's device numbers;
 optionally.
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1175784435.2719.18.camel@shinybook.infradead.org>
References: <1175696383.2774.24.camel@shinybook.infradead.org>
	<20070405.233101.106261123.anemo@mba.ocn.ne.jp>
	<1175784435.2719.18.camel@shinybook.infradead.org>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Apr 2007 10:47:15 -0400, David Woodhouse <dwmw2@infradead.org> wrote:
> > Is major 204 minor 192 already allocated?
> 
> Of course. The reason it took so long to provide this patch after the
> 'pmac_zilog doesn't load' bug got reported was because I was waiting for
> the new allocation.
> 
> > Few weeks ago, I sent a patch to allocate 192...199 for other serial
> > driver 
> 
> Were those numbers assigned to you or did you just make them up?

What I did is just send a patch includeing devices.txt changes to
lkml, device@lanana.org, and some others.

Maybe I should have sent "request" (not patch) mail to
device@lanana.org first?

---
Atsushi Nemoto
