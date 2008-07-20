Return-Path: <linux-kernel-owner+w=401wt.eu-S1758520AbYGTSOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520AbYGTSOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 14:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757815AbYGTSOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 14:14:31 -0400
Received: from 1wt.eu ([62.212.114.60]:1864 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757621AbYGTSOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 14:14:30 -0400
Date: Sun, 20 Jul 2008 20:14:26 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: el es <el_es_cr@yahoo.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: Kernel version : what about s.yy.ww.tt scheme ?
Message-ID: <20080720181426.GA29189@1wt.eu>
References: <loom.20080717T083755-676@post.gmane.org> <alpine.LNX.1.10.0807171140030.18697@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0807171140030.18697@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 11:48:37AM +0200, Jan Engelhardt wrote:
> 
> On Thursday 2008-07-17 10:51, el es wrote:
> 
> >Hello,
> >inspired by the bikeshed painting contest, I got the following idea :
> >
> >The scheme to be s.yy.ww.tt, that is :
> >
> >s - series, as it is now (freedom to Linus to bump it to 3 when BKL is removed
> >for example ;) )
> >yy - two (in a hundred years, three) digits of the year
> >Now the interesting part begins which is
> >ww - the number of the week of the release. This will be between 1 and 52 (53)
> >tt - the number of the week of stable release. As above.
> 
> Interesting idea.
> 
> >Take a hypotetical new-scheme 2.8.30 release (roughly the current
> >2.6.26, didn't count these weeks). Linus starts to accumulate
> >patches for 2.8.30-rcX as usual, and when he is ready to release,
> >puts the release week number instead of 30 - let's assume it is a
> >2.8.40 then, more or less. By the time, the stable team produces
> >2.8.30.[32,34,36,38,40 and so on]. If the weeks leap into the next
> >year, stable team puts e.g. 2.8.30.9.01 (yy.ww).
> 
> -stable usually overlaps with master. But I don't like version
> numbers long as binutils and "2.8.30.9.01" have.

also, causes trouble when stable releases cross a year boundary, or
when there are several ones in a week. The stable release should
only be a counter, not a date.

Willy

