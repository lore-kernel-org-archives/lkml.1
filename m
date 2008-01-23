Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbYAWNw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbYAWNw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 08:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbYAWNwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 08:52:51 -0500
Received: from mail.hevs.ch ([153.109.23.15]:47225 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbYAWNwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 08:52:50 -0500
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH 6/6] atmel_serial: Add DMA support
Date: Wed, 23 Jan 2008 14:52:55 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Victor <linux@maxim.org.za>, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org, Remy Bohmer <linux@bohmer.net>,
       Chip Coldwell <coldwell@redhat.com>
References: <1201013444-30370-1-git-send-email-hskinnemoen@atmel.com> <200801231418.38997.marc.pignat@hevs.ch> <20080123143503.764bc8cf@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080123143503.764bc8cf@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801231452.55388.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 January 2008, Haavard Skinnemoen wrote:
> On Wed, 23 Jan 2008 14:18:38 +0100
...
> GFP_DMA doesn't have anything to do with alignment, AFAIK.
I don't even know if it does something for at91 or avr32, but there is a flag
for dma memory, so we should use it.

...
> No, please don't. If you're thinking of dma_alloc_coherent(), it means
> that the cache will be bypassed when accessing the buffer (slower), and
> that the size will be rounded up to the next multiple of the page size
> (larger). If the sole purpose of doing that is to get properly aligned
> buffers, we might as well use the page allocator directly.
ok.

Marc


