Return-Path: <linux-kernel-owner+w=401wt.eu-S1760948AbYGOR0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948AbYGOR0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbYGORZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:25:53 -0400
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:58593 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754063AbYGORZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:25:53 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Date: Tue, 15 Jul 2008 19:25:49 +0200
User-Agent: KMail/1.9.9
Cc: david@lang.hm, jeff@garzik.org, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <1216077806.27455.85.camel@shinybook.infradead.org> <alpine.DEB.1.10.0807150931290.16109@asgard.lang.hm> <alpine.LFD.1.10.0807150936070.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807150936070.3017@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807151925.50432.elendil@planet.nl>
X-OriginalArrivalTime: 15 Jul 2008 17:25:50.0990 (UTC) FILETIME=[D3EEF2E0:01C8E69F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2008, you wrote:
> So I think the _infrastructure_ is important. But the extreme "you have
> to split it off entirely" mindset is equally as stupid as the "you must
> compile it into the module" mindset.

Agreed. All I've wanted to say is that having the _option_ to continue to 
compile it into the module can simplify certain use cases, including my 
current use of the kernel's own deb-pkg target for private builds of the 
kernel for testing purposes.

One thing I would dearly like to see is the ability to choose a different 
location for firmware for my own custom built kernels than the location 
used for firmware from official Debian kernel packages so that at least 
those two don't clash.
Doesn't look like that is possible with current git head.
