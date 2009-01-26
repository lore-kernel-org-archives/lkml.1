Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbZAZV6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbZAZV6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 16:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZAZV6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 16:58:35 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34741 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751500AbZAZV6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 16:58:34 -0500
Date: Mon, 26 Jan 2009 21:58:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@lst.de>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@lst.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: devpts multiple instances feedback
Message-ID: <20090126215853.5cb30d29@lxorguk.ukuu.org.uk>
In-Reply-To: <20090126215542.GA20760@lst.de>
References: <20090103155209.GA17988@lst.de>
	<20090105210940.GA31629@us.ibm.com>
	<20090126215542.GA20760@lst.de>
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

> > That was also one of the reasons for the default 000 mode on the pts/ptmx
> > device node
> 
> So just make it 000 but always created it.

That still allows it to be subverted with some security rulesets -
remember root can open a 000 file by default.

