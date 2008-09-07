Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbYIGJ6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbYIGJ6E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 05:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbYIGJ5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 05:57:52 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:8869 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752908AbYIGJ5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 05:57:51 -0400
Message-ID: <48C3A584.6040005@panasas.com>
Date: Sun, 07 Sep 2008 12:57:24 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Chris Leech <christopher.leech@intel.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/3] 24-bit types: typedef and macros for accessing 3-byte
 arrays as integers
References: <20080905165732.16689.50256.stgit@localhost.localdomain>
In-Reply-To: <20080905165732.16689.50256.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Sep 2008 09:56:40.0040 (UTC) FILETIME=[0638D680:01C910D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Leech wrote:
> Both iSCSI and Fibre Channel make use of 24-bit big-endian values in
> frame headers.  This patch defines __be24 and __le24 typedefs for a
> structure wrapped around a 3-byte array, and macros to convert back and
> forth to a 32-bit integer.
> 
> The undefs in iscsi_proto.h are because of the different calling
> convention for the existing hton24 macro in the iSCSI code.  iSCSI will
> be converted in a subsequent patch.
> 
> Signed-off-by: Chris Leech <christopher.leech@intel.com>
<snip>

Chris please don't cross-post to a mailing list that is members only.
I press reply-all when on linux-scsi or linux-kernel, and then I get
accused of pocking where I don't belong. So just don't do that.

And my advise to the devel@open-fcoe.org mailing list. Drop the
members only. It is useless with it. I know because I made the same
mistake with my osd-dev@open-osd.org. Believe me the span-filter
at mailman is fine and the span that will get through is not that bad.

Boaz
