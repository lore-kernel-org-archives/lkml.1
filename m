Return-Path: <linux-kernel-owner+w=401wt.eu-S1161132AbXCVVxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161132AbXCVVxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 17:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161130AbXCVVxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 17:53:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46296 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161121AbXCVVxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 17:53:52 -0400
Date: Thu, 22 Mar 2007 21:53:51 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: request_queue_t depends on CONFIG_BLOCK
Message-ID: <20070322215351.GA7216@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Olaf Hering <olaf@aepfle.de>, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org
References: <20070322215234.GA13219@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322215234.GA13219@aepfle.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 10:52:34PM +0100, Olaf Hering wrote:
> How can this compile error be fixed properly?
> request_queue_t is inside CONFIG_BLOCK,
> ide_drive_s (and likely others) use it unconditionally.
> 
> 
>   CC      arch/powerpc/kernel/setup_64.o
> In file included from linux-2.6.21-rc4/arch/powerpc/kernel/setup_64.c:23:

start looking for the problem here.  Why does you arch code include ide.h?

