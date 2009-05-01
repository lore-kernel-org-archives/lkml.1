Return-Path: <linux-kernel-owner+w=401wt.eu-S1759295AbZEALs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295AbZEALs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 07:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbZEALsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 07:48:19 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:42795 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbZEALsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 07:48:18 -0400
Date: Fri, 1 May 2009 13:50:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel-doc: restrict syntax for private: and public:
Message-ID: <20090501115028.GD22023@uranus.ravnborg.org>
References: <20090428151757.0547392d.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428151757.0547392d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 03:17:57PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> scripts/kernel-doc can (incorrectly) delete struct members that
> are surrounded by /* ... */ <struct members> /* ... */
> if there is a /* private: */ comment in there somewhere also.
> 
> Fix that by making the "/* private:" only allow whitespace
> between /* and "private:", not anything/everything in the world.
> 
> This fixes some erroneous kernel-doc warnings that popped up
> while processing include/linux/usb/composite.h.

Applied to kbuild-next.

	Sam
