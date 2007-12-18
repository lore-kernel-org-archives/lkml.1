Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbXLRNrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbXLRNrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 08:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbXLRNq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 08:46:57 -0500
Received: from relay2.sgi.com ([192.48.171.30]:40367 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755126AbXLRNqz (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 08:46:55 -0500
Date: Wed, 19 Dec 2007 00:46:44 +1100
From: David Chinner <dgc@sgi.com>
To: Bret Towe <magnade@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: xfs mknod regression
Message-ID: <20071218134644.GO4396912@sgi.com>
References: <dda83e780712172048n4d40cfcbw4a4d3106fc99f02e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dda83e780712172048n4d40cfcbw4a4d3106fc99f02e@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 08:48:40PM -0800, Bret Towe wrote:
> I hit a bug in 2.6.24-rc looks to be in 2.6.23 also so not sure how
> long it's been there
> with an xfs filesystem pbuilder has an issue using device files it
> makes for chroot
> the mknod command looks to work fine the file is created
> however when attempting to use one of the created files you see
> something like the below
> 
> ghoststar dev # echo "hi" > null
> bash: null: No such device or address
> ghoststar dev # ls -l null
> crw-rw-rw- 1 root root 1, 3 2007-12-17 20:34 null
> ghoststar dev # ls -l /dev/null
> crw-rw-rw- 1 root root 1, 3 2007-10-05 17:29 /dev/null
> ghoststar dev # echo "hi" > /dev/null
> ghoststar dev #

Ok. Works on 2.6.22. doesn't work on latest xfsdev. I'll
look into it.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
