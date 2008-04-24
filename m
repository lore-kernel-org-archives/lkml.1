Return-Path: <linux-kernel-owner+w=401wt.eu-S1759822AbYDXNCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759822AbYDXNCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 09:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYDXNB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 09:01:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34189 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbYDXNB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 09:01:56 -0400
Message-ID: <481084AE.5030607@garzik.org>
Date: Thu, 24 Apr 2008 09:01:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: fix legacy mode PCI IDE controllers
References: <20080424125155.GA5048@jurassic.park.msu.ru>
In-Reply-To: <20080424125155.GA5048@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> Legacy IDE resources were never properly allocated on most
> alpha platforms, so IDE expectedly stopped working after
> commit 10f000a2fd805e8ccfe988e8615545467bb7f7df (generic
> pci_enable_resources).
> 
> Always allocate "fixed" PCI resources before doing anything else;
> remove Cypress IDE quirk, as it's a generic problem which is
> handled in common PCI probe code.
> 
> Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Acked-by: Jeff Garzik <jgarzik@redhat.com>


