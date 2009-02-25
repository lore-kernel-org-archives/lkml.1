Return-Path: <linux-kernel-owner+w=401wt.eu-S1761436AbZBYPtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761436AbZBYPtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbZBYPtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:49:03 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49526 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbZBYPtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:49:01 -0500
Date: Wed, 25 Feb 2009 15:48:56 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nick Piggin <npiggin@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch][rfc] fs: move bdev code out of buffer.c
Message-ID: <20090225154856.GO28946@ZenIV.linux.org.uk>
References: <20090225094419.GF22785@wotan.suse.de> <49A51EFF.4020600@garzik.org> <20090225105338.GH22785@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225105338.GH22785@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 11:53:38AM +0100, Nick Piggin wrote:

> If you have a look at it, it's all dealing with buffercache and
> filesystem metadata I think. So I think fs/block_dev.c is the
> right place for it.

There are bits of fs/block_dev.c that belong in block/*; not all of
it, though.
