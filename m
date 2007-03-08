Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbXCHRMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbXCHRMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbXCHRMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:12:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33835 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbXCHRMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:12:14 -0500
Date: Thu, 8 Mar 2007 17:12:12 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>, David Brown <dmlb2000@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gdb@sourceware.org
Subject: Re: PAGE_SIZE Availability Inconsistency
Message-ID: <20070308171212.GA19872@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Roman Zippel <zippel@linux-m68k.org>,
	David Brown <dmlb2000@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	gdb@sourceware.org
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com> <20070306092917.GA5226@infradead.org> <200703080318.04631.zippel@linux-m68k.org> <20070308090031.GB7373@infradead.org> <1173369229.3550.2.camel@laptopd505.fenrus.org> <20070308160852.GB9916@infradead.org> <45F0426C.8000009@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F0426C.8000009@zytor.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 09:05:48AM -0800, H. Peter Anvin wrote:
> Christoph Hellwig wrote:
> >No, no no.  We should never export PAGE_SIZE.  We might export NBPG
> >as deprecated symbol for gdb if it really needs it, but that should
> >happen only on a.out systems, and it it should be a true constant,
> >not depending on PAGE_SIZE.
> >
> >I've Cc'ed the gdb list on whether they have any comments on this
> >issue.
> 
> By the way, it's a massive snafu that the swap area magic number is 
> dependent on PAGE_SIZE.  There is absolutely no good reason for that.

Yeah, now that you mention it I remember having problems with that
in the past.  We should probably create a new swap format that avoids
this problem.  I'll put it on my ever growing todo list.
