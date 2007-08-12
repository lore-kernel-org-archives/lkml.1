Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbXHLDOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbXHLDOQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 23:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbXHLDOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 23:14:05 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:59403 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbXHLDOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 23:14:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=aRJgbfdFVTceapQGZG28tMnZCM/h3fkMDhzeZnzoa33nj96CJGA4z8icbiloZPOe/9JkYzY0dawwKZXN1Mx+aA3ApdU2Zx2+KP5tZkfSJkNepWGNAdCmbEYKSxeBEz1OUfAXlT2O6QzP3i0b1Jmg26oFqlaXkhNGM8LJJ1nBRso=
Message-ID: <8e4fc8270708112014h5f4e9bf1ua9565eab60f915c1@mail.gmail.com>
Date: Sat, 11 Aug 2007 21:14:00 -0600
From: "Michael Bourgeous" <sts.nitrogen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Driver-level memory management
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I'm working on a driver for older HDTV cards based on the TL880 chip.
These cards typically have 16MB of their own memory, which is
available to me over the PCI bus.  Various functions of the card
require me to manage this memory, allocating and freeing chunks of it
as necessary.  I can easily include my own allocation and management
code, but I'm sure this is a problem that has been solved before.
I've found two interesting sets of functions, the kmem_cache_* and
mempool_* functions, but neither does quite what I'm looking for.  So,
in a sentence, my question is this: Does the kernel provide memory
pool functions that would allow me to call the appropriate equivalent
of kmalloc/kfree, using the card's memory as the pool instead of
actually allocating physical or virtual memory?

By the way, I am not subscribed to the LKML, so please include my
address in any responses.

Thanks,
Mike Bourgeous
http://myhd.sf.net/
