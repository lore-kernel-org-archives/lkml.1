Return-Path: <linux-kernel-owner+w=401wt.eu-S1161080AbXB0JWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161080AbXB0JWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 04:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161084AbXB0JWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 04:22:31 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:47471 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161080AbXB0JW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 04:22:29 -0500
Message-ID: <45E3F853.3010302@garzik.org>
Date: Tue, 27 Feb 2007 04:22:27 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH]: Fix __devinit & __devexit declarations in de2104x driver
References: <20070226183611.11886.61545.sendpatchset@prarit.boston.redhat.com>
In-Reply-To: <20070226183611.11886.61545.sendpatchset@prarit.boston.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Prarit Bhargava wrote:
> Resending (originally sent 2007-02-14).
> 
> __devinit & __devexit cleanups for de2104x driver.
> 
> Fixes MODPOST warnings similar to:
> 
> WARNING: drivers/net/tulip/de2104x.o - Section mismatch: reference to
> .init.text:de_init_one from .data.rel.local after 'de_driver' (at offset 0x20)
> WARNING: drivers/net/tulip/de2104x.o - Section mismatch: reference to
> .exit.text:de_remove_one from .data.rel.local after 'de_driver' (at offset 0x28)
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>

doesn't apply to current kernel


