Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865Ab0ACQzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab0ACQzS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 11:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809Ab0ACQzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 11:55:14 -0500
Received: from netrider.rowland.org ([192.131.102.5]:36040 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750949Ab0ACQzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 11:55:13 -0500
Date: Sun, 3 Jan 2010 11:55:10 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Boaz Harrosh <bharrosh@panasas.com>
cc: James Bottomley <James.Bottomley@suse.de>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>, Benny Halevy <bhalevy@panasas.com>,
       Stable Tree <stable@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [osd-dev] [PATCH] scsi_lib: Bug in completion of bidi commands
In-Reply-To: <4B406D62.8060500@panasas.com>
Message-ID: <Pine.LNX.4.44L0.1001031149380.29885-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jan 2010, Boaz Harrosh wrote:

> > What patch of mine are you referring to?  So far James has rejected all
> > the patches I have submitted recently.  I'm going to try again in the 
> > near future...
> > 
> 
> OK, that's my answer, I didn't know.
> 
> Would you want that I attempt that collapsing of scsi_end_request() into scsi_io_completion
> and the cleanup that implies? (that's the patch I meant.)

Okay, I don't mind if you would like to rewrite that patch.  The 
version I wrote didn't just move code from one subroutine to another; 
it also made a few semantic changes (the retry counter and the "error" 
argument to blk_end_request()).  You'll probably want to break it 
up into a few patches, where the first simply moves the code around and 
the later ones do more significant things.

As I recall, the most recent version of that patch is here:

	http://marc.info/?l=linux-scsi&m=123991011815404&w=2

Alan Stern

