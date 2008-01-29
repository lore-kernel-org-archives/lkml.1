Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbYA2Jbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbYA2Jbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 04:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYA2Jbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 04:31:37 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:14658 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836AbYA2Jbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 04:31:36 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <479E6323.5030200@zytor.com>
References: <1201560133.17053.36.camel@cthulhu.hellion.org.uk>
	 <479E6323.5030200@zytor.com>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 09:31:18 +0000
Message-Id: <1201599078.5301.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.46.209.99
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: PATCH/RFC: bzImage payload as compressed ELF file.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-28 at 15:20 -0800, H. Peter Anvin wrote:
> Ian Campbell wrote:
> > 
> > What would be the preferred way of allowing bootloaders/domain builders
> > to find the compressed payload? Tacking the offset from the end onto the
> > end as I have done for the moment seems pretty skanky...
> > 
> 
> As Jeremy already mentioned, putting a pointer to the compressed ELF 
> image in the bzImage header (and bumping the version number to 2.08) is 
> the right way to go about it.  The compression format (for now, always 
> gzip) can then be identified in the usual way via compression format 
> magic number.
> 
> As I've previously expressed, I'm much happier with this approach than 
> having the compressor portion itself be an ELF image, so I'm happy to 
> see this patch.  However, I think it needs to ride a cycle in -mm, so 
> although I didn't see any problems from a cursory look I might not get a 
> chance to do a detailed review until the merge window is over.

That's good enough for me -- I shall press on...

Cheers,
Ian.

-- 
Ian Campbell

Pascal:
	A programming language named after a man who would turn over
	in his grave if he knew about it.
		-- Datamation, January 15, 1984

