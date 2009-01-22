Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbZAVUdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbZAVUdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 15:33:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbZAVUcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 15:32:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46442 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbZAVUcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 15:32:53 -0500
Date: Thu, 22 Jan 2009 15:32:49 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, viro@ZenIV.linux.org.uk, oleg@redhat.com,
       linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Message-ID: <20090122203248.GA20159@infradead.org>
References: <20090115153211.663df310@bike.lwn.net> <20090122065104.2787df2d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122065104.2787df2d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 06:51:04AM -0800, Andrew Morton wrote:
> OK, replacing a lock_kernel() with a spin_lock(&global_lock) is pretty
> straightforwad.  But it's really really sad.  It basically leaves a great
> big FIXME in there.  It'd be better to fix it.


Umm, we've been discussiong this in and out a guestimated million times.

Let's go forward with Jon's patch which is on obvious improvement and
if it shows problems later on we can revisit it.

There's this proverb about premature optimization, ya' know?

