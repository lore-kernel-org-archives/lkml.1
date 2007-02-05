Return-Path: <linux-kernel-owner+w=401wt.eu-S933254AbXBESo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254AbXBESo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933039AbXBESo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:44:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34735 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669AbXBESo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:44:26 -0500
Date: Mon, 5 Feb 2007 18:44:10 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Tony Jones <tonyj@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, linux-security-module@vger.kernel.org,
       agruen@suse.de, viro@zeniv.linux.org.uk
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Message-ID: <20070205184410.GA20672@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
	linux-security-module@vger.kernel.org, agruen@suse.de,
	viro@zeniv.linux.org.uk
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just FYI:  Al was very opposed to the idea of passing the vfsmount to
the vfs_ helpers, so you should discuss this with him.

Looking at the actual patches I see you're lazy in a lot of places.
Please make sure that when you introduce a vfsmount argument somewhere
that it is _always_ passed and not just when it's conveniant.  Yes, that's
more work, but then again if you're not consistant anyone half-serious
will laught at a security model using this infrasturcture.

