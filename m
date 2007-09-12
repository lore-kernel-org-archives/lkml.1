Return-Path: <linux-kernel-owner+w=401wt.eu-S970789AbXILRJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970789AbXILRJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967206AbXILRJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:09:40 -0400
Received: from ns.firmix.at ([62.141.48.66]:60618 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030234AbXILRJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:09:39 -0400
Subject: Re: Building a kernel-source RPM (not a kernel RPM)?
From: Bernd Petrovitsch <bernd@firmix.at>
To: Dan Stromberg <dstromberglists@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <pan.2007.09.12.16.13.41.195991@gmail.com>
References: <pan.2007.09.12.16.13.41.195991@gmail.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 12 Sep 2007 19:09:26 +0200
Message-Id: <1189616966.31502.75.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.314 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.314 required=5
X-Spam-Score: -2.314 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-12 at 09:13 -0700, Dan Stromberg wrote:
> I sent this to kernel newbies first, and while I got one response there,
> it answered a different question than the one I was asking...

Are you sure?

> I'm on a SuSE system.
> 
> I'm working on automating the install of said system, but it needs a
> Linus kernel - 2.6.21.7 specifically, and it needs kernel source too so
> that we can build modules in the field as needed.

Find a kernel-source.*.src.rpm or kernel-*.src.rpm or whatever SuSE uses
for
nameing convention and reverse engineer the .spec file.
Fedora BTW abandoned kernel-source* and they have now a website with a
description
how to produce a configured kernel source tree (e.g. for out-of-tree
modules).

> I see you can make an rpm of a bootable kernel with "make rpm".

Well, then there must be a .spec file somewhere which just wants to be
extended.

> Is there a streamlined way of building a corresponding kernel-source
> RPM?  Or do people pretty much all just dump the source in /usr/src, and

Yes, you put all the steps you do by hand into the .spec file. That's
it.

> manually update symlinks as needed?  If the latter, what symlinks need
> to be updated?

Actually nowadays usually there no "sym-link updating" anymore necessary
-
just put the correct ones in /lib/modules/$(uname -r)/ and the full name
in
/boot/grub/menu.lst.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


