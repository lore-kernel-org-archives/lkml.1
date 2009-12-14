Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbZLNPcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbZLNPcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 10:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbZLNPck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 10:32:40 -0500
Received: from thunk.org ([69.25.196.29]:44689 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbZLNPcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 10:32:39 -0500
Date: Mon, 14 Dec 2009 10:32:33 -0500
From: tytso@mit.edu
To: Masa <masa.korg@gmail.com>
Cc: Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
       Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [How to upload our driver to "kernel.org"] Would you give me
 your advice?
Message-ID: <20091214153233.GE4867@thunk.org>
Mail-Followup-To: tytso@mit.edu, Masa <masa.korg@gmail.com>,
	Mithlesh Thukral <mithlesh@linsyssoft.com>,
	devel@driverdev.osuosl.org,
	Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= <ariveira@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <c7ac85d60912140256j4e1aa0edn9abba53ab1855ed5@mail.gmail.com>
 <20091214122649.2d914941@varda>
 <200912141751.36699.mithlesh@linsyssoft.com>
 <c7ac85d60912140645n5dbcadedie1200ce5d3a9cb8d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7ac85d60912140645n5dbcadedie1200ce5d3a9cb8d@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 11:45:10PM +0900, Masa wrote:
> Oh! Do I have to base our patches to the latest kernel?
> May be so.
> And the community feedback is important.
> It seems to need big effort and we will make every effort anyway.

There are resources available to help you with getting your patches
based on the latest kernel version.  There are many ways in which a
company can be involved with supporting their hardware with a fully
supported Linux device driver.

One model is one where the hardware company employs an engineer who is
actively involved with Linux community and is constantly upgrading and
developing their device driver against the latest kernel, and then
group such as the Driver Backport Workgroup[1] will backport drivers
to various enterprise kernels.  Some companies like this model because
they retain control over the development of the device driver, and
they can also update it to support hardware not yet released for sale;
some companies such as Intel and IBM, have been able to use this model
to assure that the latest mainstream kernel has support for a new
version of their hardware device at or before the moment it is
released for sale to the general public.

Another model is one where the company makes some combination of (1)
hardware specifications, (2) patches against an older kernel, and (3)
hardware available to developers (the Linux Foundation can help
faciliate this), and then a group such as the Linux Driver Project[2]
can help write a driver or port the driver to the latest kernel.  This
is done on a volunteer basis, and so how quickly this might happen is
less under the control of the hardware company involved.

There are many other models in between these two extremes, depending
on how closely the company is willing and interested to work with the
Linux development community.  For example, the upstream maintainer may
be a volunteer, who gets free hardware samples (and possibly
occasional contract work) to support the hardware, but the company is
less involved than the "full engagement" model where their engineer is
the primary mainstream developer, and but more involved than the
company dumps some specs, sample code, and some hardware and is
otherwise not involved.

A general overview of some of the issues involved in why things work
they way they do can be found here [3].

Best regards,

Theodore Y. Ts'o
Chief Technical Officer, Linux Foundation
STSM, IBM Linux Technology Center
Medford, Massachusetts
(617) 245-5616, T/L 930-1182
(781) 391-2699 (fax)
(781) 526-0121 (cell)

[1] http://www.linuxfoundation.org/collaborate/workgroups/driver-backport
[2] http://www.linuxdriverproject.org/foswiki/bin/view
[3] http://www.linuxfoundation.org/collaborate/publications/linux-driver-model
