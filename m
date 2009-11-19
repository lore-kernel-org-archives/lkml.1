Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbZKSOs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbZKSOs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 09:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbZKSOs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 09:48:58 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:53397 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbZKSOs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 09:48:58 -0500
Date: Thu, 19 Nov 2009 14:48:53 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: David Zeuthen <david@fubar.dk>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, linux-hotplug@vger.kernel.org
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle
	changes
Message-ID: <20091119144853.GA1398@srcf.ucam.org>
References: <20091118200712.GA14026@srcf.ucam.org> <ac3eb2510911181306g221e8940xfbcf8b8e7fa9a56e@mail.gmail.com> <20091118213355.GA16630@srcf.ucam.org> <ac3eb2510911190309y6d0d8445wd907fc5664595c6f@mail.gmail.com> <20091119130107.GB20949@srcf.ucam.org> <ac3eb2510911190529p6810508fve4941f3077dfd3d9@mail.gmail.com> <20091119141634.GA311@srcf.ucam.org> <ac3eb2510911190625i7432644aod6e99829b8a03dc4@mail.gmail.com> <20091119143008.GA719@srcf.ucam.org> <ac3eb2510911190634m20947c86w78340d22eff290ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510911190634m20947c86w78340d22eff290ca@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 03:34:53PM +0100, Kay Sievers wrote:

> Single-subscriber event interfaces are usually a no-go for generic
> infrastructure like this. We still have the unmodified HAL running
> until it is dead, and this works only because there are no such
> awkward interfaces. In a few years we will probably have diskfoo
> replacing dk-disks, and then ... :)

If you've got any ideas for what a multi-subscriber interface would look 
like, I'm happy look at it. I don't think there's an especially 
compelling use-case for one right now so I'm not enthusiastic about the 
additional complexity that'd be required, but as long as there's basic 
agreement that it's not practical to do this in userspace then we're at 
least on the same page.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
