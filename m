Return-Path: <linux-kernel-owner+w=401wt.eu-S1761862AbXEPMJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761862AbXEPMJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbXEPMJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:09:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45010 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424AbXEPMJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:09:29 -0400
Subject: Re: [PATCH 1 of 2] block_page_mkwrite() Implementation V2
From: David Woodhouse <dwmw2@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <18993.1179310769@redhat.com>
References: <20070318233008.GA32597093@melbourne.sgi.com>
	 <18993.1179310769@redhat.com>
Content-Type: text/plain
Date: Wed, 16 May 2007 20:09:19 +0800
Message-Id: <1179317360.2859.225.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 11:19 +0100, David Howells wrote:
> The start and end points passed to block_prepare_write() delimit the region of
> the page that is going to be modified.  This means that prepare_write()
> doesn't need to fill it in if the page is not up to date. 

Really? Is it _really_ going to be modified? Even if the pointer
userspace gave to write() is bogus, and is going to fault half-way
through the copy_from_user()?

-- 
dwmw2

