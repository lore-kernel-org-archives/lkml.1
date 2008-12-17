Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756217AbYLQBDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYLQBDr (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 20:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYLQBDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 20:03:37 -0500
Received: from eazy.amigager.de ([213.239.192.238]:32966 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbYLQBDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 20:03:36 -0500
Date: Wed, 17 Dec 2008 02:03:34 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Very slow header cache in mutt if the maildir is on ext3
Message-ID: <20081217010334.GA1212@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20081217001625.GA3250@x61> <20081217005210.GA889@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217005210.GA889@dose.home.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 01:52:10 +0100, Tino Keitel wrote:

[...]

> OK, after glancing at the strace output again, I see that the seek
> offsets are much more linear in the XFS case, whereas they are pretty
> random in the ext3 case.  I guess that this is connected to the order
> of the files in the maildir, which depends on the FS type.  So this is
> a bug in mutt which makes reading the header cache dead slow if the
> files are in an inconvenient order.

Just for the records: I tested again on ext3 with dir_index disabled,
and the cache was read as quickly as with XFS.

Regards,
Tino

