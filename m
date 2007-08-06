Return-Path: <linux-kernel-owner+w=401wt.eu-S1765038AbXHFMwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765038AbXHFMwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 08:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763636AbXHFMwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 08:52:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48913 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbXHFMwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 08:52:13 -0400
Date: Mon, 6 Aug 2007 13:52:12 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Olaf Hering <olh@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       libc-alpha@sources.redhat.com
Subject: Re: glibc and make headers_install_all provide /usr/include/scsi
Message-ID: <20070806125212.GB12896@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Olaf Hering <olh@suse.de>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, libc-alpha@sources.redhat.com
References: <20070806124546.GA2117@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806124546.GA2117@suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 02:45:46PM +0200, Olaf Hering wrote:
> 
> glibc and make headers_install_all provide /usr/include/scsi
> One of them has to go.
> 
> A quick diff shows no differences, expect:

..

> Which copy should be provided by a distributor?

The glibc one of course.  The kernel scsi.h should never have been
added to the list of exportable headers.  

