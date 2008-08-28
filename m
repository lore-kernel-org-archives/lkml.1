Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbYH1S1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbYH1S1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbYH1S0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:26:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:48135 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbYH1S0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:26:55 -0400
Message-ID: <48B6ED9C.3080109@kernel.org>
Date: Thu, 28 Aug 2008 20:25:32 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org> <48B6E844.3050508@kernel.org> <20080828181406.GA23898@kroah.com>
In-Reply-To: <20080828181406.GA23898@kroah.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 18:26:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> No, I'm not worried about the performance, just that this should be
> simple as we can just pass "arg" to userspace without touching it as it
> just came from userspace, right?

For simple ones, that's how it's gonna be handled.  Those copying in and
out kicks in when the @arg is pointer or worse data structure which can
contain pointers.

> Oh wait, there are process space issues at play here that I'm totally
> forgetting about, right?

:-)

Thanks.

-- 
tejun
