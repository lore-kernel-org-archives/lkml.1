Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbZCSQCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbZCSQCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 12:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbZCSQCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 12:02:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:34778 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbZCSQCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:02:24 -0400
Subject: Re: Q: NFSD readdir in linux-2.6.28
From: David Woodhouse <dwmw2@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "hooanon05@yahoo.co.jp" <hooanon05@yahoo.co.jp>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20090319153704.GZ14127@parisc-linux.org>
References: <8036.1237474444@jrobl>
	 <1237475837.16359.106.camel@macbook.infradead.org>
	 <20090319153704.GZ14127@parisc-linux.org>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 16:01:59 +0000
Message-Id: <1237478519.16359.110.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-19 at 09:37 -0600, Matthew Wilcox wrote:
> Should we also add this?

Maybe. It was actually perfectly OK when XFS was doing that to _itself_
though, and that BUG_ON() would have triggered. It's only now that we're
doing it unconditionally that it's really a problem.

-- 
dwmw2

