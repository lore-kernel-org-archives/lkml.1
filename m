Return-Path: <linux-kernel-owner+w=401wt.eu-S1761874AbXJMLef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761874AbXJMLef (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 07:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbXJMLeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 07:34:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35692 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbXJMLeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 07:34:24 -0400
Date: Sat, 13 Oct 2007 12:33:48 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mchehab@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] v4l: copy_to_user() is not a good method name
Message-ID: <20071013113348.GC11464@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@ftp.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	mchehab@infradead.org, linux-kernel@vger.kernel.org
References: <20071013072524.GF8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071013072524.GF8181@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2007 at 08:25:24AM +0100, Al Viro wrote:
> Breaks on any target that has copy_to_user() defined as a non-trivial
> macro.

Where did that CALL crap come from?  We normally don;t accept junk like
that.

