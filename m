Return-Path: <linux-kernel-owner+w=401wt.eu-S1767778AbXEDJsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767778AbXEDJsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 05:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767779AbXEDJsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 05:48:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51396 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767764AbXEDJsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 05:48:22 -0400
Date: Fri, 4 May 2007 10:48:17 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Kristian H??gsberg <krh@redhat.com>
Cc: John Stoffel <john@stoffel.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] firewire: char device interface
Message-ID: <20070504094817.GA31811@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Kristian H??gsberg <krh@redhat.com>,
	John Stoffel <john@stoffel.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux1394-devel <linux1394-devel@lists.sourceforge.net>
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de> <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de> <17976.44988.734513.121919@smtp.charter.net> <4638FE91.6050001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4638FE91.6050001@redhat.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 05:11:45PM -0400, Kristian H??gsberg wrote:
> The firewire-cdev.h file is meant to be a self-contained userspace header 
> file and shouldn't include other kernel header files.  All duplicated 
> values are standardized ieee1394 values and won't ever change.  I should 
> put a #ifndef __FW_COMMON_DEFINES protection around the duplicate values, I 
> guess, but I'm just wondering why I never saw a "symbol redefined" 
> warning...

No, defining things in two places is not okay.  Just add a new header
that defines these protocol constants, which needs to be included by
userspace that wants to use them.

