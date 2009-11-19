Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbZKSOaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbZKSOaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 09:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756362AbZKSOaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 09:30:13 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35972 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326AbZKSOaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 09:30:12 -0500
Date: Thu, 19 Nov 2009 14:30:08 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: David Zeuthen <david@fubar.dk>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, linux-hotplug@vger.kernel.org
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle
	changes
Message-ID: <20091119143008.GA719@srcf.ucam.org>
References: <20091118195342.GA13627@srcf.ucam.org> <ac3eb2510911181203r1be5c3dajdacec94f196d550c@mail.gmail.com> <20091118200712.GA14026@srcf.ucam.org> <ac3eb2510911181306g221e8940xfbcf8b8e7fa9a56e@mail.gmail.com> <20091118213355.GA16630@srcf.ucam.org> <ac3eb2510911190309y6d0d8445wd907fc5664595c6f@mail.gmail.com> <20091119130107.GB20949@srcf.ucam.org> <ac3eb2510911190529p6810508fve4941f3077dfd3d9@mail.gmail.com> <20091119141634.GA311@srcf.ucam.org> <ac3eb2510911190625i7432644aod6e99829b8a03dc4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510911190625i7432644aod6e99829b8a03dc4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 03:25:59PM +0100, Kay Sievers wrote:
> On Thu, Nov 19, 2009 at 15:16, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > It could, but it seems a bit of a hack. It'd still also require the
> > timer to be in the kernel, so we might as well expose that to userspace.
> 
> Sure, but a userspace configurable policy for an in-kernel disk-idle
> powermanagent sounds fine, compared to a single-subscriber
> userspace-only disk-idle event interface. :)

Well, we still need to expose this for the access pattern modifying. I 
really don't see the issue with the single subscriber being devkit-disks 
- none of the operations involved are atomic, so we're inherently racy 
here.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
