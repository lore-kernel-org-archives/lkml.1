Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750931Ab0BLFHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 00:07:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40947 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab0BLFHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 00:07:08 -0500
Date: Fri, 12 Feb 2010 05:07:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-s390@vger.kernel.org, linux-next@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: mmotm 2010-02-10 - BUG at fs/dcache.c:677!
Message-ID: <20100212050703.GT30031@ZenIV.linux.org.uk>
References: <201002110043.o1B0hKxW008835@imap1.linux-foundation.org>
 <8576.1265942657@localhost>
 <20100211191427.6ff9aec6.akpm@linux-foundation.org>
 <4B74DE40.5030401@ce.jp.nec.com>
 <20100212050104.GS30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100212050104.GS30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 05:01:04AM +0000, Al Viro wrote:

> > So the bug seems introduced between next-20100205 and next-20100208.
> > 
> > Isn't this change missing the equivalent of "dput(old)"?
> 
> Argh...  Nice catch, and yes, it is.

Fixed, pushed to hera, should propagate to git.kernel.org shortly.
