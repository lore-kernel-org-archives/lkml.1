Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbYCBLzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbYCBLzd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 06:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbYCBLzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 06:55:24 -0500
Received: from ns.firmix.at ([62.141.48.66]:1533 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbYCBLzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 06:55:23 -0500
Subject: Re: swap file over jffs2 partition
From: Bernd Petrovitsch <bernd@firmix.at>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47C84B40.6000501@gmx.net>
References: <47C772E9.2000000@gmx.net>
	 <1204276763.18969.10.camel@tara.firmix.at>  <47C84B40.6000501@gmx.net>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Sun, 02 Mar 2008 12:55:09 +0100
Message-Id: <1204458909.4078.30.camel@gimli.at.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-7.fc7) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.331 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.331 required=5
X-Spam-Score: -2.331 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fre, 2008-02-29 at 20:13 +0200, Dimitrios Apostolou wrote:
> Bernd Petrovitsch wrote:
> > On Fre, 2008-02-29 at 04:50 +0200, Dimitrios Apostolou wrote:
[....]
> >> swap...). And to avoid wearing out the flash storage too fast, I 'm 
> > 
> > Swapping (and constantly writing logfiles) will wear it out much faster
> > than without. Perhaps not at development time but for sure in the field.
> 
> That's why I want to do it over a wear-levelling layer. Given that the 
> partition is large enough it will hopefully take a while to wear it out.

The wear-levelling only makes all erase blocks/chunks/... wear out at
the same rate (at least more or less). It doesn't avoid or reduce
wearing out, it just distributes it.
Even if you do it: Make sure you have the better flash chips, not the
cheap ones with only 5000 (or so) write cycles. Or even MLCs ....

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

