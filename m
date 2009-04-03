Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbZDCCFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbZDCCFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 22:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbZDCCFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 22:05:34 -0400
Received: from thunk.org ([69.25.196.29]:38172 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbZDCCFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 22:05:34 -0400
Date: Thu, 2 Apr 2009 22:05:25 -0400
From: Theodore Tso <tytso@mit.edu>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: EXT4-ish "fixes" in UBIFS
Message-ID: <20090403020525.GI9870@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christian Kujau <lists@nerdbynature.de>,
	Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <49CCCB0A.6070701@nokia.com> <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 05:09:39PM -0700, Christian Kujau wrote:
> On Fri, 27 Mar 2009, Artem Bityutskiy wrote:
> > They just say - this is file-system bug, it is fixed in
> > ext4 now, just fix the bug in UBIFS.
> 
> Would *mounting* the filesystem with "-o sync" help? This way no 
> filesystem "fixes" are needed and userland would not have to be rewritten.

It will, but you might not like the performance....  the reason why
it's there is that some users might want the particular tradeoff, but
it probably wouldn't make a good default.

						- Ted
