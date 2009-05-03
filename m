Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbZECV4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbZECV4t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 17:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbZECV4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 17:56:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34417 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791AbZECV4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 17:56:34 -0400
Date: Sun, 3 May 2009 23:56:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Tridgell <tridge@samba.org>, Steve French <sfrench@us.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090503215628.GB1368@ucw.cz>
References: <1241199689.13073.6.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241199689.13073.6.camel@norville.austin.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-05-01 12:41:29, Dave Kleikamp wrote:
> From: Andrew Tridgell <tridge@samba.org>
> Subject: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
> 
> When this option is enabled the VFAT filesystem will refuse to create
> new files with long names. Accessing existing files with long names
> will continue to work.
> 
> File names to be created must conform to the 8.3 format.  Mixed case is
> not allowed in either the prefix or the suffix.


CONFIG_AVOID_MS_PATENTS ?

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
