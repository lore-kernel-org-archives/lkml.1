Return-Path: <linux-kernel-owner+w=401wt.eu-S933351AbZHVUP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351AbZHVUP6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 16:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933329AbZHVUP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 16:15:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57342 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933304AbZHVUP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 16:15:57 -0400
Date: Sat, 22 Aug 2009 16:15:59 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: Kernel 2.6.30.4 XFS(..?) regression (& with/2.6.31-rc6)
Message-ID: <20090822201558.GA17955@infradead.org>
References: <alpine.DEB.2.00.0908080422440.12329@p34.internal.lan> <00980BBF-1206-4BEF-A8AE-B4A8DAE7EC27@sgi.com> <alpine.DEB.2.00.0908090605080.16485@p34.internal.lan> <alpine.DEB.2.00.0908110624420.22426@p34.internal.lan> <20090816022331.GA2309@infradead.org> <alpine.DEB.2.00.0908171024380.12533@p34.internal.lan> <alpine.DEB.2.00.0908220624440.30321@p34.internal.lan> <20090822142550.GA10003@infradead.org> <alpine.DEB.2.00.0908221044420.30321@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908221044420.30321@p34.internal.lan>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 22, 2009 at 10:45:13AM -0400, Justin Piszcz wrote:
>> Yes, entirely possible.   All the crypto loop / dm implementation used
>> to have a tendency to never complete I/O once in a while, although that
>> didn't happen anymore recently.
>
> Ok,
>
> What is the best way to debug the issue? git bi-sects between 2.6.29.x 
> and 2.6.31-rc6? or?

Well, that would be a good way to find it.  But I'm personally not
interested in spending much time on debugging a problem if it only
happens with fishy out of tree modules.

