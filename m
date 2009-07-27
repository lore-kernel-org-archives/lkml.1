Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407AbZG0HoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbZG0HoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 03:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbZG0HoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 03:44:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59395 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbZG0HoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 03:44:18 -0400
Date: Mon, 27 Jul 2009 03:44:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Don't export scsi kernel variables in userspace
	headers.
Message-ID: <20090727074418.GA14765@infradead.org>
References: <20090725021026.GA6942@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090725021026.GA6942@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 10:10:26PM -0400, Dave Jones wrote:
> Found with make headers_check
> 
> /usr/include/scsi/scsi.h:159: userspace cannot call function or variable defined in the kernel
> /usr/include/scsi/scsi.h:285: userspace cannot call function or variable defined in the kernel

The headers shouldn't be exported at all because scsi/ headers are
exported from glibc.

