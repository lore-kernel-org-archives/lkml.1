Return-Path: <linux-kernel-owner+w=401wt.eu-S1764883AbXHVQU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764883AbXHVQU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761924AbXHVQUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:20:10 -0400
Received: from 1wt.eu ([62.212.114.60]:2244 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764650AbXHVQUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:20:09 -0400
Date: Wed, 22 Aug 2007 18:06:23 +0200
From: Willy Tarreau <w@1wt.eu>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2.6.20.17 review 32/58] fs: 9p/conv.c error path fix
Message-ID: <20070822160623.GA11973@1wt.eu>
References: <20070822083844.%N@1wt.eu> <20070822084023.%N@1wt.eu> <a4e6962a0708220853n7689985fj71ba19b67e17ae5d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4e6962a0708220853n7689985fj71ba19b67e17ae5d@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 10:53:02AM -0500, Eric Van Hensbergen wrote:
> On 8/22/07, Willy Tarreau <w@1wt.eu> wrote:
> > When buf_check_overflow() returns != 0 we will hit kfree(ERR_PTR(err))
> > and it will not be happy about it.
> >
> > Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-off-by: Willy Tarreau <w@1wt.eu>
> Acked-by: Eric Van Hensbergen <ericvh@gmail.com>
> 
> This seems to be in the current code as well, I'll forward-port the patch...
 
Thanks Eric,
Willy

