Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbYKLX5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbYKLX5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYKLX5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:57:21 -0500
Received: from kroah.org ([198.145.64.141]:41236 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751658AbYKLX5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:57:21 -0500
Date: Wed, 12 Nov 2008 15:56:00 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Can you add the staging tree to -next?
Message-ID: <20081112235600.GA27554@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm starting to get people sending me patches against -next for the
drivers/staging/ tree that don't apply as -next does not include my
quilt tree of staging patches.

Can you please pick it up?  You can put it at the end of your series,
and the 'make allmodconfig' option disables building anything in the
drivers/staging/ subdirectory, so it should not have any build or merge
conflicts with anything.

It can be found at:
	http://kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-05-staging/
and is a quilt tree.

It will follow all the same rules as other trees, with patches only for
the next merge window (2.6.29 right now) in it.

thanks,

greg k-h
