Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbXGDImW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbXGDImW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 04:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbXGDImN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 04:42:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34253 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052AbXGDImM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 04:42:12 -0400
Date: Wed, 4 Jul 2007 09:42:11 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Karel Zak <kzak@redhat.com>
Cc: List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
Message-ID: <20070704084211.GA19128@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Karel Zak <kzak@redhat.com>,
	List util-linux-ng <util-linux-ng@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070703221156.GY14825@petra.dvoda.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070703221156.GY14825@petra.dvoda.cz>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2007 at 12:11:56AM +0200, Karel Zak wrote:
>  mount(8) doesn't include filesystem detection code anymore. You
>  have to compile --with-fsprobe={blkid,volume_id}, and libblkid
>  (e2fsprogs) or libvolume_id (udev >= v110) is required.

Sorry, but it's really annoying to pull in a filesystem-specific devel
package for that.  Having a library is fine, but please move the library
into util-linux so it's always available without another dependency.  That
way xfsprogs could for example drop it's own detection library aswell.

>  The package build system is now based on autotools. The build system
>  supports  separate CFLAGS and LDFLAGS for suid programs (SUID_CFLAGS,
>  SUID_LDFLAGS). For more details see the README file

And this is really dumb.  autotools is a completely pain in the ass and
not useful at all for linux-only tools.

