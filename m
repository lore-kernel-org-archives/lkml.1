Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbZGNMzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbZGNMzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 08:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZGNMzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 08:55:13 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57710 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbZGNMzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 08:55:12 -0400
Date: Tue, 14 Jul 2009 13:55:07 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
       rui.zhang@intel.com, corentincj@iksaif.net
Subject: Re: [PATCH 1/3] backlight: Allow drivers to update the core, and
	generate events on changes
Message-ID: <20090714125507.GA21992@srcf.ucam.org>
References: <1247517685-7719-1-git-send-email-mjg@redhat.com> <1247574573.23871.8.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247574573.23871.8.camel@dax.rpnet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 01:29:33PM +0100, Richard Purdie wrote:

> My main concern is that we don't start getting bug reports of 'missing'
> events and have clearly defined expectations of when we see what kind of
> events. For example, should an event be emitted when low battery causes
> the backlight to be limited? How about console blanking events turning
> off the backlight? Are there any other occasions we should be emitting
> change events and do we need to audit other drivers?

These are all good questions. I'm working through the drivers now, and 
there's definitely a few more that need doing.

> Also, are "userspace" and "kernel" as meaningful as they could be? Would
> "sysfs" and "hwkeys" make more sense and allow for other future hardware
> differences? Perhaps someone will tie the backlight to an ambient light
> sensor for example...

Yes, though we'd need to extend the interface slightly in that case to 
allow the information to be provided. The ALS case is a good one - if 
that ends up happening in-kernel then there probably shouldn't be a 
UI update.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
