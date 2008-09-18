Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbYIRPRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbYIRPRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 11:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbYIRPRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 11:17:03 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:9281 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754225AbYIRPRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:17:01 -0400
Date: Thu, 18 Sep 2008 19:16:59 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>, linuxppc-dev@ozlabs.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Patches to support QE USB Host Controller
Message-ID: <20080918151659.GA20140@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

More than a month has passed since the first post. Unfortunately
David didn't comment on the "1/3" patch, and Greg said that he
have to wait for it...

(Laurent Pinchart also said that he is interested in the first
patch, so here are at least two users for that call.)

So I'm reposting this again. The first patch has changed in a way
that now it exports gpio_desc instead of just a function, this keeps
the gpiolib code optimized.

Previous patchset and discussion can be found here:

http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-08/msg03687.html


Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
