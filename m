Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbYB1Jbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbYB1Jbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 04:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbYB1Jbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 04:31:39 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:30822 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753599AbYB1Jbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 04:31:38 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Mark McLoughlin <markmc@redhat.com>
In-Reply-To: <1204187174-27143-2-git-send-email-ijc@hellion.org.uk>
References: <1204187174-27143-1-git-send-email-ijc@hellion.org.uk>
	 <1204187174-27143-2-git-send-email-ijc@hellion.org.uk>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 09:31:22 +0000
Message-Id: <1204191082.5446.13.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.46.209.99
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 2/2] x86/xen: Disable DMI parsing in Xen kernel.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Actually scratch this patchset -- its not sufficient. For example
ddcprobe in userspace causes the exact same issue vs 0xa0000.

Looks like the only sane solution will be to mark regions between
640K-1M reserved early on in boot.

Ian.
-- 
Ian Campbell

Put no trust in cryptic comments.

