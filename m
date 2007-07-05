Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbXGEOqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbXGEOqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 10:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757094AbXGEOqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 10:46:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:9343 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362AbXGEOqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 10:46:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=i8ERy8RBEQwEcoZdPXrXa6pvF1tpQMSwggW36Es+xzZegAxOICJHYhvNYIY1sbU6aR9GB/W6bs315yKiXENW45D4C0/qG3HFiB6+JHeiRYP/etB4GvrVN8KFN0J1n30wPIJ/xidZCm3LcnEj8hx0jBWIfEAwhbjc9x5DyChRNPk=
Message-ID: <2c0942db0707050746v2b8cdc9ew2c4656736b52895d@mail.gmail.com>
Date: Thu, 5 Jul 2007 07:46:01 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Oliver Neukum" <oliver@neukum.org>,
       "Miklos Szeredi" <miklos@szeredi.hu>, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, benh@kernel.crashing.org
In-Reply-To: <20070705142318.GA22598@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com>
	 <200707051528.34754.oliver@neukum.org>
	 <20070705134632.GA22177@srcf.ucam.org>
	 <200707051609.25887.rjw@sisk.pl>
	 <20070705142318.GA22598@srcf.ucam.org>
X-Google-Sender-Auth: b74988ed83714186
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/5/07, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Thu, Jul 05, 2007 at 04:09:24PM +0200, Rafael J. Wysocki wrote:
> > On Thursday, 5 July 2007 15:46, Matthew Garrett wrote:
> > > I have a model for STD that avoids the need to freeze the entirity of
> > > userspace, but I need to find some more time to flesh it out.
> >
> > You can just describe it, as far as I'm concerned. :-)
>
> The basic model is that nobody's really described a use-case where we
> actually care about restoring system state. What people want is to be
> able to restore application state.

Hmm, careful. There are a bunch of people who use suspend2 exactly
because it saves and restores the page cache, leaving the system in a
usable state without waiting for the universe to swap back in from
disk. It makes a big difference on older laptops with slow drives.
While the other advantages you list for process cryogenics are pretty
neat, let's remember that the 99% use case for STD is laptops.
