Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbZG0I00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbZG0I00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 04:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbZG0I0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 04:26:25 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:43185 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbZG0I0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 04:26:25 -0400
Date: Mon, 27 Jul 2009 10:26:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Don't export scsi kernel variables in userspace
	headers.
Message-ID: <20090727082623.GA18747@merkur.ravnborg.org>
References: <20090725021026.GA6942@redhat.com> <20090727074418.GA14765@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090727074418.GA14765@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 03:44:18AM -0400, Christoph Hellwig wrote:
> On Fri, Jul 24, 2009 at 10:10:26PM -0400, Dave Jones wrote:
> > Found with make headers_check
> > 
> > /usr/include/scsi/scsi.h:159: userspace cannot call function or variable defined in the kernel
> > /usr/include/scsi/scsi.h:285: userspace cannot call function or variable defined in the kernel
> 
> The headers shouldn't be exported at all because scsi/ headers are
> exported from glibc.
Where does glibc get these headers from?

If glibc have their own private copy then the headers should indeed be exported
so we avoid such mess.

	Sam
