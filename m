Return-Path: <linux-kernel-owner+w=401wt.eu-S1759605AbYBSR53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605AbYBSR53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 12:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbYBSR5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 12:57:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44546 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823AbYBSR5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 12:57:06 -0500
Date: Tue, 19 Feb 2008 09:53:39 -0800
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] AMD opteron mm config numa etc
Message-ID: <20080219175339.GB8344@kroah.com>
References: <200802190319.28699.yinghai.lu@sun.com> <20080219112322.GD7204@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219112322.GD7204@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 12:23:22PM +0100, Ingo Molnar wrote:
> 
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
> > please check some amd opteron related mmconf and numa patches
> > 
> > could make up for system that system have acpi problem or still can 
> > mmconf and numa when acpi=off
> 
> Greg, any deep objections against these patches? (other than that they 
> need a good amount of testing) I personally think that the more 
> independent the kernel is of the whims of the BIOS, the better ...

No objection from me, other than they need a LOT of testing.  Oh, and
the networking patch is still wrong, and the poster has been told this
numerous times, which makes me wonder how well the pci bridge patch was
tested...

thanks,

greg k-h
