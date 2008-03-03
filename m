Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbYCCOTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbYCCOTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYCCOT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:19:26 -0500
Received: from ns.firmix.at ([62.141.48.66]:5912 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbYCCOTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:19:25 -0500
Subject: Re: swap file over jffs2 partition
From: Bernd Petrovitsch <bernd@firmix.at>
To: David Newall <davidn@davidnewall.com>
Cc: Dimitrios Apostolou <jimis@gmx.net>, linux-kernel@vger.kernel.org
In-Reply-To: <47CAB23C.1010602@davidnewall.com>
References: <47C772E9.2000000@gmx.net>
	 <1204276763.18969.10.camel@tara.firmix.at>  <47C84B40.6000501@gmx.net>
	 <1204458909.4078.30.camel@gimli.at.home> <47CAB23C.1010602@davidnewall.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Mon, 03 Mar 2008 15:19:09 +0100
Message-Id: <1204553949.15430.62.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
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

On Mon, 2008-03-03 at 00:27 +1030, David Newall wrote:
> Bernd Petrovitsch wrote:
> > The wear-levelling only makes all erase blocks/chunks/... wear out at
> > the same rate (at least more or less). It doesn't avoid or reduce
> > wearing out, it just distributes it.
> 
> Surely a unit with one defective block and a squillion good blocks is
> faulty.  Sure it is.  It has a fault, which is what it means to be

Several are very probably faulty as NAND flashes initially already have
bad blocks (but there a re some more on that chip to compensate for
that).
Even if just 1 of a squillion (erase-)blocks is gone. But that's now and
only the first. More to follow sooner or later .....
I don't think that "writing to swap space" is in any way limited or
minimized but assumes normal harddisks. So it is not like you are
writing to the flash chip only on "save in some UI or on a firmware
update.

> faulty.  Spread the wear of that one block over all squillion and one
> blocks and you get a much longer lifetime.  It seems intuitive that
> distributing wear significantly increases time to failure.

Yes, that's the idea. Nevertheless it places "load" on the flash chips.

Actually I'm curious how fats it is and how well it works (and with
which flash chips exactly) if one simply tries it out. If it actually
works.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


