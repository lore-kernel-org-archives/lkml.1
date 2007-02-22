Return-Path: <linux-kernel-owner+w=401wt.eu-S1751945AbXBVVpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbXBVVpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbXBVVpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:45:17 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55811 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbXBVVpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:45:15 -0500
Date: Thu, 22 Feb 2007 21:45:02 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@osdl.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, gregkh@novell.com, hch@infradead.org
Subject: Re: [Patch 2/2] cciss: add shutdown support (replaces reboot notifier)
Message-ID: <20070222214502.GA19670@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>,
	akpm@osdl.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, gregkh@novell.com
References: <20070222213845.GA14162@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070222213845.GA14162@beardog.cca.cpqcorp.net>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 03:38:45PM -0600, Mike Miller (OS Dev) wrote:
> Patch 2/2
> 
> This adds support for struct pci_driver shutdown and negates the previous NAK'ed
> reboot_notifier patch. It's much easier, wish I had know about this before. Thanks to
> Christoph for pointing this out.

Just sondering, where should we have put information about this so driver
writers/maintainers like you would have found it easily?

