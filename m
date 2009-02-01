Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbZBAQcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbZBAQcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 11:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZBAQcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 11:32:00 -0500
Received: from verein.lst.de ([213.95.11.210]:49155 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbZBAQb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 11:31:59 -0500
Date: Sun, 1 Feb 2009 17:31:50 +0100
From: Christoph Hellwig <hch@lst.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@lst.de>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: devpts multiple instances feedback
Message-ID: <20090201163150.GB3416@lst.de>
References: <20090103155209.GA17988@lst.de> <20090105210940.GA31629@us.ibm.com> <20090126215542.GA20760@lst.de> <497E3222.2060301@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497E3222.2060301@zytor.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 01:58:58PM -0800, H. Peter Anvin wrote:
> Christoph Hellwig wrote:
> >>
> >>That was also one of the reasons for the default 000 mode on the pts/ptmx
> >>device node
> >
> >So just make it 000 but always created it.
> >
> 
> That's what we do...

Only if the kernel is compiled with CONFIG_DEVPTS_MULTIPLE_INSTANCES
(which will be clearly superflous after the cleanup patches because
the amount of addition code is minimal) _and_ you mount with
-o newinstance, and then you have another -o ptmxmode=foo option
to make it useable.

Really, even if we're really cautious there should be no compiletime
and just a single mount time option, but I'm not even sure that is
needed with the default zero mode.

