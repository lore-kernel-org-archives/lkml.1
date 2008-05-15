Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbYEOSlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbYEOSlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYEOSla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:41:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbYEOSl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:41:29 -0400
Date: Thu, 15 May 2008 14:03:21 -0400
From: Bill Nottingham <notting@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Problems with suspend and USB storage
Message-ID: <20080515180321.GB22097@nostromo.devel.redhat.com>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20080515163315.GA17779@nostromo.devel.redhat.com> <20080515175413.GA10910@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515175413.GA10910@dose.home.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tino Keitel (tino.keitel@gmx.de) said: 
> On Thu, May 15, 2008 at 12:33:15 -0400, Bill Nottingham wrote:
> 
> [...]
> 
> > Is there any way to get sane behavior out of suspend/resume with
> > USB storage?
> 
> I use this since 2.6.18, with my /home, one swap partition and some
> other partitions on a USB hard disk. However, I use LVM, what might be
> a good idea as the device names doesn't matter in this case (just a
> guess). I never had any such failure with suspend to disk and to RAM as
> described above.

Throwing device-mapper in the middle (for crypto) doesn't actually help
the situation.

In any case, even if device names aren't stable across boot, they sort
of need to be across suspend and resume for active filesystems...

Bill
