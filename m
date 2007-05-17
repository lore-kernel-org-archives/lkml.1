Return-Path: <linux-kernel-owner+w=401wt.eu-S1760437AbXEQV32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760437AbXEQV32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbXEQV3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:29:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48182 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbXEQV3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:29:19 -0400
Date: Thu, 17 May 2007 22:29:13 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, dedekind@infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] ubi: kill homegrown endian macros
Message-ID: <20070517212913.GV4095@ftp.linux.org.uk>
References: <20070517143200.GA30850@lst.de> <1179413443.3642.49.camel@sauron> <20070517145653.GA968@lst.de> <1179414590.3642.69.camel@sauron> <20070517102931.6bbbad1a.akpm@linux-foundation.org> <20070517204234.GR4095@ftp.linux.org.uk> <d120d5000705171414u55af4c03m6e6d2fbcf982e3ff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000705171414u55af4c03m6e6d2fbcf982e3ff@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 05:14:26PM -0400, Dmitry Torokhov wrote:
> On 5/17/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> >
> >Ahem...  So what does
> >       x |= y;
> >turns into with that approach?
> 
> Do we want to do such kind of operations on endian-annotated data? I'd
> imagine you want to convert ot host-endianess first anyway.

Why?  When both x and y are of the same type, it's a perfectly sane and
safe operation.  And yes, sparse checks handle that.
