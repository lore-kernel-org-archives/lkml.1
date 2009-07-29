Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZG2PUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZG2PUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 11:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbZG2PUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 11:20:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53992 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbZG2PUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 11:20:46 -0400
Date: Wed, 29 Jul 2009 16:20:41 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Zhang Rui <rui.zhang@intel.com>, Richard Purdie <rpurdie@rpsys.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "corentincj@iksaif.net" <corentincj@iksaif.net>
Subject: Re: [PATCH 1/3] backlight: Allow drivers to update the core, and
	generate events on changes
Message-ID: <20090729152041.GA15650@srcf.ucam.org>
References: <1247517685-7719-1-git-send-email-mjg@redhat.com> <1247574573.23871.8.camel@dax.rpnet.com> <1247644518.26272.88.camel@rzhang-dt> <1247646153.6248.3.camel@dax.rpnet.com> <1247647105.26272.99.camel@rzhang-dt> <1247649089.20241.5.camel@dax.rpnet.com> <20090715135808.GA19054@srcf.ucam.org> <1247711974.26272.190.camel@rzhang-dt> <20090716024057.GA2461@srcf.ucam.org> <20090729150524.GD1534@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729150524.GD1534@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 05:05:24PM +0200, Pavel Machek wrote:
> > No, I mean that the only default policy you could reasonably have in the 
> > kernel would be tying the backlight directly to the ALS. And that sucks. 
> > You need some degree of smoothing, and that's a job better left to 
> > userspace.
> 
> How would that be done? Wake up userspace 100times a second so it can
> read an integer and ardd it to running average?

I don't think you'd need more than once a second, possibly modified by 
the size of the change since the last measurement. Response doesn't need 
to be immediate.

> Is ALS device stupid sensor, or can it do some smoothing/watermarks
> itself?

Generally stupid.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
