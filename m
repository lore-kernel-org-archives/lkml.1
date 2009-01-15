Return-Path: <linux-kernel-owner+w=401wt.eu-S1765169AbZAONbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765169AbZAONbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759227AbZAONan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:30:43 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:43671 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764791AbZAONam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:30:42 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "Christian Eggers" <ceggers@gmx.de>
Subject: Re: Buffer allocation for USB transfers
Date: Thu, 15 Jan 2009 14:31:19 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <496E43F4.24792.158F9B@ceggers.gmx.de>
In-Reply-To: <496E43F4.24792.158F9B@ceggers.gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151431.20204.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday 14 January 2009 19:58:44 schrieb Christian Eggers:
> For some reason the second example (kmalloc()) doesn't seem to cause problems (on 
> my platform) but is there are guarantee that kmalloc() 
> without GFP_DMA does always return a DMA capable buffer?

We depend on memory returned for GFP_KERNEL capable of DMA on PCI.
GFP_DMA is for ISA dma.

	Regards
		Oliver

