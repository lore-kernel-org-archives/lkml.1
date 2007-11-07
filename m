Return-Path: <linux-kernel-owner+w=401wt.eu-S1758954AbXKGRd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954AbXKGRd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbXKGRdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:33:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35121 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142AbXKGRdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:33:14 -0500
Date: Wed, 7 Nov 2007 17:33:07 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Andreas Schwab <schwab@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] aacraid: don't assign cpu_to_le32(int) to u8
Message-ID: <20071107173307.GB25560@infradead.org>
References: <jefxzqqeha.fsf@sykes.suse.de> <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 10:58:12AM -0500, Salyzyn, Mark wrote:
> Good point, thanks. The intent of the management applications
> utilization of this AIF report is to observe the LSB of the value of
> integer value in BlinkLED. The actions of the cpu_to_le32 actually
> breaks this and reports the wrong content in swapped architectures.
> 
> This attached follow-up patch is against current scsi-misc-2.6 *after*
> the application of the 'don't assign cpu_to_le32(constant) to u8' patch
> submitted by Stephen Rothwell which has already been taken by the -mm
> tree. Inspection of other areas of the aacraid driver came up blank for
> similar style bugs.

Did anyone run the driver through sparse to see if we have more issues like
this?

