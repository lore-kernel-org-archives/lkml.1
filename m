Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbXJ0Qip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbXJ0Qip (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 12:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbXJ0Qij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 12:38:39 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:56166 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbXJ0Qii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 12:38:38 -0400
Date: Sat, 27 Oct 2007 12:35:32 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sg_next() for struct scatterlist is confusing
In-Reply-To: <20071027183130.0215e355@siona>
Message-ID: <Pine.LNX.4.64.0710271234280.3409@localhost.localdomain>
References: <Pine.LNX.4.64.0710270734210.24293@localhost.localdomain>
 <20071027183130.0215e355@siona>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007, Haavard Skinnemoen wrote:

> On Sat, 27 Oct 2007 07:39:40 -0400 (EDT)
> "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
>
> >   note how the comment says that the next entry will "usually" be
> > sg+1, "but" not if it's actually a pointer.
> >
> >   however, as i read the code above, sg is *always* incremented before
> > that testing.  is that correct?  am i just misreading something?  or
> > could the comment have been a bit clearer?
>
> If it increments sg and finds a "chain" entry, it will follow it to
> the next sg array instead of just returning it. Which makes sense
> because the chain entry itself isn't a valid entry in the sg list.

yes, i finally twigged on that after a few more minutes.  it, of
course, makes sense, but it sure doesn't match the comment that's at
the top of that file.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
