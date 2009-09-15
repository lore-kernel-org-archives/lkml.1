Return-Path: <linux-kernel-owner+w=401wt.eu-S1758418AbZIOTKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbZIOTKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758358AbZIOTKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:10:45 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44104 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758309AbZIOTKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:10:44 -0400
Date: Tue, 15 Sep 2009 20:10:36 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@suse.de>
Cc: Andreas Mohr <andi@lisas.de>, Alan Stern <stern@rowland.harvard.edu>,
       laurent.pinchart@skynet.be, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: usb autosuspend is history after S2R (also on 2.6.31; UVC?)
Message-ID: <20090915191036.GA7713@srcf.ucam.org>
References: <20090915185145.GA31490@rhlx01.hs-esslingen.de> <20090915190045.GA734@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915190045.GA734@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 12:00:45PM -0700, Greg KH wrote:

> Could you try that?  A certian hardware manufacturer is insisting that
> this patch solves problems, which I have not been able to validate, and
> it would be good to get some independant tests.

I'd be surprised if this actually fixed anything - it's equivalent to 
just echoing "enable" into the autosuspend file at device bind time. 
I've been waiting until we ship beta and get more user feedback before 
pushing it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
