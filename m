Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbZIYJ6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbZIYJ6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 05:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbZIYJ6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 05:58:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:43258 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751158AbZIYJ6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 05:58:33 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1/fg8dH5hTf44SSSnrJpam48k6A/s3E7eaeNfRZUv
	GIlG33vL+Kxzf8
Date: Fri, 25 Sep 2009 11:58:31 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Joe Perches <joe@perches.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       git@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: git merge conflict resolution?
Message-ID: <20090925095831.GA17721@atjola.homenet>
References: <200909250101.n8P11HwO030173@hera.kernel.org>
 <1253841510.18126.10.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1253841510.18126.10.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009.09.24 18:18:30 -0700, Joe Perches wrote:
> Question about how git does merge conflict resolution.
> 
> This patch doesn't really apply, and the results after the
> patch aren't what at least I expect.
[...]
> Russell's patch removes the "(moderated for non-subscribers)"
> from each entry, yet the final result includes it.
> 
> Can someone help me understand why?

If you look at baea7b946f00a291b166ccae7fcfed6c01530cc6, you see:

    Merge branch 'origin' into for-linus

    Conflicts:
        MAINTAINERS

Git was unable to automatically merge that file, as there were
conflicting changes. That merge was done by Russel King, and _he_
decided that the result should include the "(moderated for ...)" part.

Björn
