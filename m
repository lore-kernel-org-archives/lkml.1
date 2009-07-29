Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbZG2Pd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbZG2Pd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 11:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZG2Pd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 11:33:57 -0400
Received: from dan.rpsys.net ([93.97.175.187]:59336 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbZG2Pd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 11:33:56 -0400
Subject: Re: [PATCH 1/3] backlight: Allow drivers to update the core, and
	generate events on changes
From: Richard Purdie <rpurdie@rpsys.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pavel Machek <pavel@ucw.cz>, Zhang Rui <rui.zhang@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "corentincj@iksaif.net" <corentincj@iksaif.net>
In-Reply-To: <20090729152041.GA15650@srcf.ucam.org>
References: <1247517685-7719-1-git-send-email-mjg@redhat.com>
	 <1247574573.23871.8.camel@dax.rpnet.com>
	 <1247644518.26272.88.camel@rzhang-dt>
	 <1247646153.6248.3.camel@dax.rpnet.com>
	 <1247647105.26272.99.camel@rzhang-dt>
	 <1247649089.20241.5.camel@dax.rpnet.com>
	 <20090715135808.GA19054@srcf.ucam.org>
	 <1247711974.26272.190.camel@rzhang-dt>
	 <20090716024057.GA2461@srcf.ucam.org> <20090729150524.GD1534@ucw.cz>
	 <20090729152041.GA15650@srcf.ucam.org>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 16:31:39 +0100
Message-Id: <1248881499.2289.137.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 16:20 +0100, Matthew Garrett wrote:
> On Wed, Jul 29, 2009 at 05:05:24PM +0200, Pavel Machek wrote:
> > > No, I mean that the only default policy you could reasonably have in the 
> > > kernel would be tying the backlight directly to the ALS. And that sucks. 
> > > You need some degree of smoothing, and that's a job better left to 
> > > userspace.
> > 
> > How would that be done? Wake up userspace 100times a second so it can
> > read an integer and ardd it to running average?
> 
> I don't think you'd need more than once a second, possibly modified by 
> the size of the change since the last measurement. Response doesn't need 
> to be immediate.

It depends how fancy your algorithm is really. If its not that complex
and not floating point etc. then you probably could have some basic
kernel implementation in a few lines of code which used a timer callback
to smooth things out. I agree that userspace should be able to run the
show if it wants to or its some horrible complex calculation though.

Assuming no complaints I'll queue the patches from this series in the
backlight tree in the next could of days. I'll probably include the ACPI
bits since they're more backlight than APCI unless Len has an objection.

Cheers,

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

