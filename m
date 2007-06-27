Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbXF0MhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbXF0MhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 08:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbXF0MhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 08:37:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42366 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbXF0MhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 08:37:08 -0400
Date: Wed, 27 Jun 2007 13:37:05 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Neil Booth <neil@daikokuya.co.uk>
Cc: Josh Triplett <josh@freedesktop.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070627123705.GP21478@ftp.linux.org.uk>
References: <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk> <467F531A.3030702@freedesktop.org> <20070626221040.GI21478@ftp.linux.org.uk> <20070626221134.GA21350@ftp.linux.org.uk> <20070626233226.GO7590@daikokuya.co.uk> <20070627001803.GJ21478@ftp.linux.org.uk> <20070627115245.GP7590@daikokuya.co.uk> <20070627121948.GN21478@ftp.linux.org.uk> <20070627122628.GR7590@daikokuya.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627122628.GR7590@daikokuya.co.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 09:26:28PM +0900, Neil Booth wrote:
> DR 312 clarified the meaning of "known constant size"
> 
>    http://www.open-std.org/jtc1/sc22/wg14/www/docs/dr_312.htm
> 
> in the sensible way, thankfully, so your example is actually invalid.

<looks>  Aha.  OK...

I'd say that 6.7.5.2[4] should simply have "element type is not a variable
length array" instead, regardless of clarification of "known constant size",
since element type is not allowed to be incomplete in any case.  Would be
more readable...  But yes, clarification makes sense anyway.
