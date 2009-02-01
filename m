Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZBAQaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZBAQaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 11:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZBAQaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 11:30:10 -0500
Received: from verein.lst.de ([213.95.11.210]:49139 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbZBAQaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 11:30:09 -0500
Date: Sun, 1 Feb 2009 17:29:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@lst.de>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: devpts multiple instances feedback
Message-ID: <20090201162958.GA3416@lst.de>
References: <20090103155209.GA17988@lst.de> <20090105210940.GA31629@us.ibm.com> <20090126215542.GA20760@lst.de> <20090126215853.5cb30d29@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126215853.5cb30d29@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 09:58:53PM +0000, Alan Cox wrote:
> > > That was also one of the reasons for the default 000 mode on the pts/ptmx
> > > device node
> > 
> > So just make it 000 but always created it.
> 
> That still allows it to be subverted with some security rulesets -
> remember root can open a 000 file by default.

root can also mknod device nodes by default.
