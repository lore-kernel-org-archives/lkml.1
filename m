Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZBAQky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZBAQky (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 11:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbZBAQkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 11:40:46 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54298 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752297AbZBAQkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 11:40:45 -0500
Date: Sun, 1 Feb 2009 16:41:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@lst.de>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: devpts multiple instances feedback
Message-ID: <20090201164104.0daafdf7@lxorguk.ukuu.org.uk>
In-Reply-To: <20090201162958.GA3416@lst.de>
References: <20090103155209.GA17988@lst.de>
	<20090105210940.GA31629@us.ibm.com>
	<20090126215542.GA20760@lst.de>
	<20090126215853.5cb30d29@lxorguk.ukuu.org.uk>
	<20090201162958.GA3416@lst.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Feb 2009 17:29:58 +0100
Christoph Hellwig <hch@lst.de> wrote:

> On Mon, Jan 26, 2009 at 09:58:53PM +0000, Alan Cox wrote:
> > > > That was also one of the reasons for the default 000 mode on the pts/ptmx
> > > > device node
> > > 
> > > So just make it 000 but always created it.
> > 
> > That still allows it to be subverted with some security rulesets -
> > remember root can open a 000 file by default.
> 
> root can also mknod device nodes by default.

That depends on your SELinux policy rules
