Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbYK1LOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbYK1LOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 06:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbYK1LN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 06:13:58 -0500
Received: from mail2.shareable.org ([80.68.89.115]:41742 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYK1LN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 06:13:57 -0500
Date: Fri, 28 Nov 2008 11:13:38 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Andreas Dilger <adilger@sun.com>
Cc: Matthew Garrett <mjg@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com,
       matthew@wil.cx
Subject: Re: [PATCH v4] relatime: Make relatime smarter
Message-ID: <20081128111338.GF6138@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127220839.GK3186@webber.adilger.int>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger wrote:
> The one problem with a 1-day default is that cron jobs like updatedb will
> revert to updating the atime on every single file every day.  It would be
> better to make it slightly more than 1 day (e.g. 25h) to avoid this and
> at least defer atime updates to every other day for files that are not
> otherwise accessed except by cron.

On my computers (laptops) updatedb doesn't run at exact 24h intervals
- that would only happen for computers powered up all the time.

-- Jamie
