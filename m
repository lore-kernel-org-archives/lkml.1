Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbXHTBM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbXHTBM5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 21:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbXHTBMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 21:12:48 -0400
Received: from smtp118.sbc.mail.re3.yahoo.com ([66.196.96.91]:41665 "HELO
	smtp118.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750811AbXHTBMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 21:12:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eP7MJkrVzYmJui1VzRRxP39OfPyoKvecA4+VDRqTbA923CvC8d5Zn3mZ9xE0b8E5jbztFCVqjpFDYAlMUV9SuzLmJFI4b07yCJV2nIsrbwsL3JgYn/oa1i2phpCZTDtYTwbUKe8rGfSwM6S/lkdASViRbPeiVXoD3QyQvxtFy6k=  ;
X-YMail-OSG: V6p9Gz4VM1mR_zcwHoWE6YCKkSaeMycWFF_TIGJyZ7wgy1VMMM.jYN_kEQ15g_P31BDH62OEew--
From: David Brownell <david-b@pacbell.net>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] ptrdiff_t is not uintptr_t, damnit
Date: Sun, 19 Aug 2007 18:12:44 -0700
User-Agent: KMail/1.9.6
Cc: Anton Altaparmakov <aia21@cam.ac.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20070819225546.GV21089@ftp.linux.org.uk> <C0FCB07A-EE48-4ABB-96A7-470C53C86A38@cam.ac.uk> <20070820005246.GX21089@ftp.linux.org.uk>
In-Reply-To: <20070820005246.GX21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708191812.44459.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 August 2007, Al Viro wrote:
> On Mon, Aug 20, 2007 at 01:27:13AM +0100, Anton Altaparmakov wrote:
> 
> > And what the cast was doing I can't remember.  I may well have just  
> > copied it from the VFS or I was perhaps trying to silence a warning  
> > and this happened to work...
> 
> ... due to sparse bug (it miscalculated address space of pointed to,
> picking top-level qualifiers for some reason; __user pointer to char
> and pointer to __user char gave the same result and so did __user long).
> That cast still made no sense...

I could believe that all came from sparse bugs.  Fixed now?
