Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbXL3VsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbXL3VsY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbXL3VsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:48:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:5422 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbXL3VsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:48:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=WPNdkPnQEwLawckD6EYQaAARPscvGGSPFypTbkX/ycv3GRsWdf+bm88K6AA/CZPYy5pHwrClWCtyDilCDG63Nl0bQ0Q2xQI5kq5ka6FuUVxubijmzrnP+VJMm9klsma4BlytzMBEaEQpr3+SfRsDYx9m+qYZ+fZu9c3Xs1uliu0=
Date: Sun, 30 Dec 2007 22:49:34 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [RFC][PATCH] byteorder: introduce le32_add_cpu & friends to
	core
Message-ID: <20071230214857.GA14177@joi>
References: <20071230190619.GA13757@joi> <20071230191825.GA6447@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071230191825.GA6447@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2007 at 07:18:25PM +0000, Christoph Hellwig wrote:
> On Sun, Dec 30, 2007 at 08:06:34PM +0100, Marcin Slusarz wrote:
> > There are many places where these functions would be useful.
> > (just look at: grep -r 'cpu_to_[ble12346]*([ble12346]*_to_cpu.*[-+]' linux-src/)
> > What do you think?
> > 
> > ps: this patch depends on http://lkml.org/lkml/2007/12/25/35
> > --
> > 
> > add inline functions which add native byte order variable to
> > little/big endian variable to core header and as an example
> > convert ext3 to use them
> 
> Various places already have this as be*_add / le*_add, so it might be
> more useful to keep those names already in use.

I found it in XFS only. Did I miss something?
be32_add is shorter than be32_add_cpu but I think it's not clear
whether second parameter is in native byte order or not.

Marcin
