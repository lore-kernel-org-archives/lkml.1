Return-Path: <linux-kernel-owner+w=401wt.eu-S1751565AbZIHQYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbZIHQYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 12:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZIHQYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 12:24:38 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:56045 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZIHQYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 12:24:38 -0400
Date: Tue, 8 Sep 2009 16:24:34 +0000
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-ide@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Limiting DMA speeds for individual IDE drives
Message-ID: <20090908161204.GA3113@gambetta>
References: <Pine.LNX.4.44L0.0909081157520.2653-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0909081157520.2653-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 12:03:48PM -0400, Alan Stern wrote:
> Is there any simple way to force the old IDE driver to limit the DMA
> speed for a particular device?
> 
> I've got a situation where a drive claims to be capable of supporting
> UDMA/100, but it's in a noisy environment and gets lots of errors at
> that speed.  I'd like to limit it to UDMA/66 or even UDMA/33.
> 
> The hdparm command should be able to do this but I can't run it until 
> the system has booted, by which time a bunch of CRC and possibly other 
> errors have already occurred.  Ideally it should be possible to limit 
> the speed starting as early as device detection, but I can't find any 
> way to do it.  Is there support for such a thing or will I have to hack 
> it in?
Does passing ide=nodma at bootime, and then having init set the DMA at
the right speed, would work?

Regards,
Frederik
