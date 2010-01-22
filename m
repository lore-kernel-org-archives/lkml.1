Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838Ab0AVPcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab0AVPcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 10:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167Ab0AVPcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:32:12 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:34358 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab0AVPcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:32:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=wjrEpLue4m/3+4z+xVEo/NcbBLqXS4DvoXUUQ32DII7AR5Wo6n8LA6VhE1SRbbgTs6
         ruYiDMFILjJGfwZ3NFOv+1gG0j1KOZVcG2PrJHpkvdDz/ntSCeWIPPzZiOa/7qoRUtmK
         yJ0Jw9UipNSlt+L9pPmiyqMhiL3MfbiVSUrYU=
Subject: [PATCH 0/4] Cleanups for mtd translation layer
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 17:31:56 +0200
Message-ID: <1264174316.24012.17.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have broken up the patch series that I created for proper
SmartMedia/xD support.

This patch series contain patches that fix hotplug & suspend/resume in
mtd translation layer.

Patches are (almost) unmodified from last submission, and well tested on
real hotplugable card.
I can say that for a long time (even before last submission) I had no
issues regarding hotplug and/or suspend resume even in exterme cases.
(like suspending the system while doing 'dd if=/dev/zero of=/dev/smblka'
or yanking the card out while read or write is performed)

First two patches, prepare ground for real work and don't add new
functionality.

Third patch adds everything needed to common translation layer to make
the hotplug work.

Last patch makes suspend/resume work much better by allowing to freeze
the IO thread, thus avoiding situation you suspend in middle of IO.


Best regards,
Maxim Levitsky


