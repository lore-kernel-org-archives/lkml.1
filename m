Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbYKFQ5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbYKFQ5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 11:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYKFQ5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 11:57:21 -0500
Received: from bu3sch.de ([62.75.166.246]:37149 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbYKFQ5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 11:57:20 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH] SSB: make it depend on PCI
Date: Thu, 6 Nov 2008 17:56:45 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
       "Mike Frysinger" <vapier@gentoo.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1225965082-31462-1-git-send-email-vapier@gentoo.org> <1225969620.3619.204.camel@johannes.berg> <8bd0f97a0811060315j7d11e1a7p257a4a1bea640f7b@mail.gmail.com>
In-Reply-To: <8bd0f97a0811060315j7d11e1a7p257a4a1bea640f7b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811061756.45493.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 November 2008 12:15:24 Mike Frysinger wrote:
> linux/ssb/ssb.h always calls pci_dma_* functions

No it doesn't. Read the code.
pci_dma_xxx functions should probably declared to no-op inlines in
the pci.h header.
However, we can also ifdef them in ssb.h.

-- 
Greetings Michael.
