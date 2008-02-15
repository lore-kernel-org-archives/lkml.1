Return-Path: <linux-kernel-owner+w=401wt.eu-S1762911AbYBOVF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762911AbYBOVF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbYBOVFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:05:03 -0500
Received: from ns.suse.de ([195.135.220.2]:55486 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398AbYBOVFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:05:00 -0500
Date: Fri, 15 Feb 2008 12:58:02 -0800
From: Greg KH <gregkh@suse.de>
To: Frans Pop <elendil@planet.nl>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [2.6.25-rc1] System no longer powers off after shutdown
Message-ID: <20080215205802.GA7583@suse.de>
References: <200802111623.38478.elendil@planet.nl> <86802c440802141538m44d64b6as827426174874979d@mail.gmail.com> <20080215065746.GA8916@suse.de> <200802151119.23325.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802151119.23325.elendil@planet.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 11:19:20AM +0100, Frans Pop wrote:
> On Friday 15 February 2008, Greg KH wrote:
> > I swear someone sent this patch in before.  Can you try this one below,
> > there seems to be an imbalance with kobject_get and _put.
> 
> I did remember seeing this patch before [1] and can confirm that it does 
> indeed fix the issue: with this patch applied to 2.6.25 git head my system 
> powers off correctly.
> 
> [1] See http://lkml.org/lkml/2008/2/8/342; also added to #9960.

Ah, thanks, for some reason I couldn't find this in my archives.

I'll add this to my queue to go to Linus.

thanks,

greg k-h
