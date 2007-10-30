Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367AbXJ3Ryf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbXJ3Ryf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbXJ3Ry1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:54:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46509 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbXJ3Ry0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:54:26 -0400
Date: Tue, 30 Oct 2007 17:54:18 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       byron.bbradley@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: XFS Fails Quality Assurance Tests on ARM
Message-ID: <20071030175418.GA17768@infradead.org>
References: <fb80ve$i5q$1@sea.gmane.org> <20070830.213901.48806818.davem@davemloft.net> <p73ps12vxrl.fsf@bingen.suse.de> <4726C577.9000209@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4726C577.9000209@sandeen.net>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 12:47:35AM -0500, Eric Sandeen wrote:
> There was a patch floating around to "fix" it but it's not on-disk
> compatible w/ x86 & friends, it just makes things consistent for arm.  I
> think packing some of these structures would take care of it, but this
> problem could use some attention & testing I think, it's been floating
> around a long time.

Do you have a pointer to that patch?  Once the unaliged fields are
identified simply using get_unaligned on them should fix this issue.

