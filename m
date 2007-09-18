Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbXIRJU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbXIRJU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbXIRJUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:20:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43916 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbXIRJUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:20:18 -0400
Date: Tue, 18 Sep 2007 10:20:13 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: 2.6.20 (XFS? related) crash after uptime of > 180 days during apt-get dist-upgrade on Debian Testing
Message-ID: <20070918092013.GA1352@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Chinner <dgc@sgi.com>,
	Justin Piszcz <jpiszcz@lucidpixels.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com
References: <Pine.LNX.4.64.0709171315210.22156@p34.internal.lan> <20070918014537.GK23367404@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918014537.GK23367404@sgi.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 11:45:37AM +1000, David Chinner wrote:
> No idea - it looks like dkpg was trying to remove a directory on the
> same path the lookup was and both have gone splat in __d_lookup on
> the same dentry. Something happened in  those 180 days that left a
> landmine that was tripped over here, I think. I can't see any way of
> tracking it down from this, but thanks for reporting it anyway,

This looks a lot like the i_sem leak that Vlad debugged.  Do you remember
where this was fixed?
