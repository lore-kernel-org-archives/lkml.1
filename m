Return-Path: <linux-kernel-owner+w=401wt.eu-S1161516AbXBHHxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161516AbXBHHxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 02:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161519AbXBHHxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 02:53:54 -0500
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:37752 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161516AbXBHHxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 02:53:54 -0500
Date: Thu, 8 Feb 2007 08:53:35 +0100
From: Paolo Ornati <ornati@fastwebnet.it>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Trevor Offner Caira <toc3@cornell.edu>
Subject: Re: PROBLEM: sata timeouts with intel 82801HB on amd64
Message-ID: <20070208085335.5e9e16db@localhost>
In-Reply-To: <45CAAD8D.7030007@shaw.ca>
References: <fa.C/AbnQN5ZU4HbNob5u7LvtyVH3U@ifi.uio.no>
	<fa.R4l8gBCDmrTiB/K/hEhS7a0vNoI@ifi.uio.no>
	<45CAAD8D.7030007@shaw.ca>
X-Mailer: Sylpheed-Claws 2.4.0 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Feb 2007 22:56:45 -0600
Robert Hancock <hancockr@shaw.ca> wrote:

> Paolo Ornati wrote:
> > If mounting XFS with "nobarrier" fixes the problem it seems that more
> > than one Seagate disk cannot handle the Cache Flush command while other
> > commands are in fly...
> 
> It's not allowed to overlap NCQ (FPDMA read/write) commands with any 
> other commands such as cache flushes. libata core guarantees that this 
> doesn't happen by deferring such requests until the FPDMA commands are 
> complete. (At least, it's supposed to..)

I didn't know that. Anyway just mounting XFS with "nobarrier" fixes
the ploblem for me... so libata is buggy or I don't know!

-- 
	Paolo Ornati
	Linux 2.6.20 on x86_64
