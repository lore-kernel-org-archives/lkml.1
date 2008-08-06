Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbYHFEtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbYHFEtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 00:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbYHFEg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 00:36:27 -0400
Received: from [116.90.133.99] ([116.90.133.99]:55218 "EHLO mars.unix.geek.nz"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbYHFEg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 00:36:26 -0400
Subject: Re: XFS noikeep remount in 2.6.27-rc1-next-20080730
From: Jasper Bryant-Greene <jasper@amiton.co.nz>
To: MusicMan529@yahoo.com
Cc: Karel Zak <kzak@redhat.com>, Dave Chinner <david@fromorbit.com>,
       Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, util-linux-ng@vger.kernel.org
In-Reply-To: <510965.21937.qm@web34502.mail.mud.yahoo.com>
References: <510965.21937.qm@web34502.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: Amiton Ltd
Date: Wed, 06 Aug 2008 16:36:35 +1200
Message-Id: <1217997395.3456.1.camel@luna.unix.geek.nz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-05 at 21:33 -0700, gus3 wrote:
> --- On Tue, 8/5/08, Dave Chinner <david@fromorbit.com> wrote:
> 
> > So what is the correct behaviour? Should the filesystem
> > *silently
> > ignore* unchangable options in the remount command, or
> > should it
> > fail the remount and warn the user that certain options are
> > not
> > allowed in remount?
> 
> How about a middle ground: ignore, but not silently? Report an error, or send it to the syslog, or both, but ultimately ignore unchangeable options, change what can be changed, and give the user/admin as much as possible.

I think the idea is to behave the same as other FS do, not to innovate.

> This can be particularly pertinent for XFS root. If it's mounted RO at first, it may (will?) need to become RW at some later point. Failing the remount could result in a system that requires a rescue CD (or lots of headaches for remote administration).

FWIW, your root filesystem does not need to be rw. I keep mine ro nearly
all the time on my laptop, only mounting rw if I need to install
software that puts files outside /usr or if I need to modify a config
file in /etc.

-jasper

