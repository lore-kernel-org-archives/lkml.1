Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbYHKWA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbYHKWA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbYHKWAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:00:12 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:47541 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbYHKWAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:00:10 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH] PNP: make the resource type an unsigned long
Date: Mon, 11 Aug 2008 15:59:01 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <489BEA31.3040101@keyaccess.nl>
In-Reply-To: <489BEA31.3040101@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808111559.01575.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 August 2008 12:39:45 am Rene Herman wrote:
> Andrew earlier commented that pci_resourec_flags() returns an unsigned 
> long. Had this hanging around a local branch. Useful?

I see hpa's point that it makes no functional difference, but I do
think it's worthwhile to make the types match.  I don't want to
debug the problem that happens when somebody adds an IORESOURCE_*
flag in the upper bits.

You probably want to send this (and the next one, which is really
a pci_resource_flags() usage despite being in drivers/pnp/quirks.c)
to Andi Kleen.

Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
