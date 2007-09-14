Return-Path: <linux-kernel-owner+w=401wt.eu-S1756765AbXINKjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbXINKjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 06:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbXINKi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 06:38:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46575 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbXINKi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 06:38:57 -0400
Date: Fri, 14 Sep 2007 11:38:50 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-box <bo.yang@lsi.com>, linux-scsi@vger.kernel.org,
       James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org,
       sumant.patro@lsi.com
Subject: Re: [PATCH 3/4] scsi: megaraid_sas - add module param max_sectors, cmd_per_lun
Message-ID: <20070914103850.GA15225@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-box <bo.yang@lsi.com>, linux-scsi@vger.kernel.org,
	James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org,
	sumant.patro@lsi.com
References: <1189514073.6082.14.camel@dhcp-75-534.se.lsil.com> <20070914033216.858d12e0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914033216.858d12e0.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 03:32:16AM -0700, Andrew Morton wrote:
> y'know, if some brave soul were to write

y'know - some brave sould already did it.

> static inline void *scsi_host_data(struct Scsi_Host *host)
> {
> 	return (void *)host->hostdata;
> }
> 
> we could remove about 100000000000 ugly casts from scsi.

it's called shost_priv, but I couldn't get a whole lot of driver
authors to switch over yet.
