Return-Path: <linux-kernel-owner+w=401wt.eu-S1765483AbYBWCJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765483AbYBWCJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 21:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758512AbYBWCJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 21:09:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56222 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbYBWCJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 21:09:19 -0500
Date: Sat, 23 Feb 2008 02:09:13 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Junio C Hamano <gitster@pobox.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Chase Venters <chase.venters@clientec.com>,
       linux-kernel@vger.kernel.org, git@vger.kernel.org
Subject: Re: Question about your git habits
Message-ID: <20080223020913.GL27894@ZenIV.linux.org.uk>
References: <200802221837.37680.chase.venters@clientec.com> <Pine.LNX.4.64.0802230221140.21077@fbirervta.pbzchgretzou.qr> <20080223014445.GK27894@ZenIV.linux.org.uk> <7vfxvk4f07.fsf@gitster.siamese.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7vfxvk4f07.fsf@gitster.siamese.dyndns.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 05:51:04PM -0800, Junio C Hamano wrote:
> Al Viro <viro@ZenIV.linux.org.uk> writes:
> 
> > On Sat, Feb 23, 2008 at 02:37:00AM +0100, Jan Engelhardt wrote:
> >
> >> >do you tend to clone the entire repository repeatedly into a series
> >> >of separate working directories
> >> 
> >> Too time consuming on consumer drives with projects the size of Linux.
> >
> > git clone -l -s
> >
> > is not particulary slow...
> 
> How big is a checkout of a single revision of kernel these days,
> compared to a well-packed history since v2.6.12-rc2?
> 
> The cost of writing out the work tree files isn't ignorable and
> probably more than writing out the repository data (which -s
> saves for you).

Depends...  I'm using ext2 for that and noatime everywhere, so that might
change the picture, but IME it's fast enough...  As for the size, it gets
to ~320Mb on disk, which is comparable to the pack size (~240-odd Mb).
