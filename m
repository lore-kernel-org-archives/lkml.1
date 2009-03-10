Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000AbZCJMrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbZCJMrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 08:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZCJMrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 08:47:06 -0400
Received: from thunk.org ([69.25.196.29]:53933 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbZCJMrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 08:47:05 -0400
Date: Tue, 10 Mar 2009 08:46:58 -0400
From: Theodore Tso <tytso@mit.edu>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: next-20090310: ext4 hangs
Message-ID: <20090310124658.GE8840@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <a4423d670903100517y42f342d4pd73c4c36f5c64dd7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670903100517y42f342d4pd73c4c36f5c64dd7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 03:17:51PM +0300, Alexander Beregalov wrote:
> Hi
> 
> It is similar to http://lkml.org/lkml/2009/2/6/304,
> http://bugzilla.kernel.org/show_bug.cgi?id=12579
> 
> I run dbench on ext4 on loop on ext3 on sparc.
> The kernel is 2.6.29-rc7-next-20090310
> e2fsprogs -1.41.4

Thanks for reporting this; does it show up on stock 2.6.29-rc7?  And
any chance you can enable LOCKDEP?  Finally, how many CPU's do you
have on your machine?

Thanks again,

						- Ted
