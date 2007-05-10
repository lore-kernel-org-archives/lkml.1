Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbXEJKJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbXEJKJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbXEJKJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:09:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54573 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbXEJKJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:09:31 -0400
Date: Thu, 10 May 2007 11:09:30 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Menny Hamburger <menny@exanet.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] interface for doing a full host scsi rescan
Message-ID: <20070510100929.GA13771@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Menny Hamburger <menny@exanet.com>, linux-kernel@vger.kernel.org
References: <A6FDE6B975803043804A49F12F49028E0F59C8@hawk.exanet-il.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6FDE6B975803043804A49F12F49028E0F59C8@hawk.exanet-il.co.il>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 01:01:55PM +0300, Menny Hamburger wrote:
> Hi,
> 
> When we do want to rescan the SCSI host, a userland script needs to be
> provided that does add/remove.
> This patch adds an interface for doing this inside the kernel - seems
> more appropriate:

/proc/scsi/scsi is deprecated, don't use it.  But you can do a full
rescan through /sys/.../scan

