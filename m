Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYE2WMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYE2WMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 18:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756004AbYE2WLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 18:11:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36030 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbYE2WLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 18:11:36 -0400
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
	kernel.
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: arjan@linux.intel.com, James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080529.140919.160813310.davem@davemloft.net>
References: <1212077700.26088.83.camel@shinybook.infradead.org>
	 <20080529164745.GA21763@kroah.com> <483F1232.4010003@linux.intel.com>
	 <20080529.140919.160813310.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 30 May 2008 01:11:00 +0300
Message-Id: <1212099060.18530.53.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 14:09 -0700, David Miller wrote:
> I've fought, like, forever, to
> keep the tg3 driver with it's firmware in-tree.  I refuse to let the
> driver get broken like that, it's staying working, and that means
> in-tree and linked into the driver.

Am I missing something here, or is the tg3 firmware contained in
'tg3FwText' and similar non-swappable u32 arrays which haven't changed
_ever_ in our current git history?

-- 
dwmw2

