Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbYHSXGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbYHSXGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 19:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYHSXGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 19:06:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbYHSXGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 19:06:00 -0400
Date: Wed, 20 Aug 2008 01:04:54 +0200
From: Karel Zak <kzak@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       sfr@canb.auug.org.au
Subject: Re: [PATCH 2/2] documentation: split and build dnotify_test program
Message-ID: <20080819230454.GH2846@nb.net.home>
References: <20080817214456.e8c765fa.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080817214456.e8c765fa.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2008 at 09:44:56PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Make dnotify_test.c source file and add it to Makefile so that
> bitrot can be prevented.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  Documentation/filesystems/00-INDEX       |    2 +
>  Documentation/filesystems/Makefile       |    2 -
>  Documentation/filesystems/dnotify.txt    |   36 -------------------------------

 $ grep -c inotify Documentation/filesystems/dnotify.txt
 0

 It would be nice to add a note that dnotify has been obsoleted by
 inotify (>= 2.6.13).

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
