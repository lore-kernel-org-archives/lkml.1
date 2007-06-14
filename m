Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbXFNXJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbXFNXJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 19:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbXFNXJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 19:09:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36016 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbXFNXJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 19:09:00 -0400
Date: Fri, 15 Jun 2007 00:08:58 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mr Bowtie <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] a100u2w: Convert into Linux style
Message-ID: <20070614230858.GA29872@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Mr Bowtie <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070615001122.0abccc5e@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070615001122.0abccc5e@the-village.bc.nu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 12:11:22AM +0100, Alan Cox wrote:
> - Remove the BSD dual licence on the new work
> - Switch the if ALPHA to if __LP64__. (struct size is then right elsewhere)

__LP64__ is not a correct check unfortunately.  Please use
CONFIG_64BIT instead.

