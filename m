Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbZENU1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbZENU1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbZENU1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:27:25 -0400
Received: from mail2.shareable.org ([80.68.89.115]:42799 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbZENU1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:27:24 -0400
Date: Thu, 14 May 2009 21:27:06 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Max Kellermann <max@duempel.org>,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] make splice more generic
Message-ID: <20090514202706.GB20363@shareable.org>
References: <20090507133734.450612199@szeredi.hu> <20090511121247.GZ4694@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090511121247.GZ4694@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> SPLICE_F_MOVE is a soft flag in that it will move if it
> can, but not fail if it can't.

According to local man page, it's not even that.

  SPLICE_F_MOVE      [...] The initial implementation of this flag  was  buggy:
		     therefore  starting  in  Linux  2.6.21 it is a *no-op*
		     (but is still permitted in a splice() call); in  the
		     future, a correct implementation may be restored.

> Perhaps we should add a flag that does pass back an error if we
> can't just move pages around, SPLICE_F_STRICT or something like
> that.

What should it do in cases where the kernel would choose to copy data,
i.e. data that isn't a whole page?

-- Jamie
