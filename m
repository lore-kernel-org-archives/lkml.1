Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753171AbYLRGWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbYLRGWv (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 01:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYLRGWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 01:22:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbYLRGWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 01:22:38 -0500
Date: Wed, 17 Dec 2008 22:22:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Andrew Paprocki" <andrew@ishiboo.com>
Cc: LKML <linux-kernel@vger.kernel.org>, dz@debian.org,
        "Federico Heinz" <fheinz@vialibre.org.ar>,
        "Andy Spencer" <spenceal@rose-hulman.edu>
Subject: Re: i8k: fails to detect Dell XPS M1530, fails to get SMM BIOS
 version with force=1
Message-Id: <20081217222221.ac2c6f3a.akpm@linux-foundation.org>
In-Reply-To: <76366b180812171707j7ad58957xf153d40efb7c7d59@mail.gmail.com>
References: <76366b180812171634k6c5a25d6uad0de0d6c514ebb5@mail.gmail.com>
	<76366b180812171707j7ad58957xf153d40efb7c7d59@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008 20:07:02 -0500 "Andrew Paprocki" <andrew@ishiboo.com> wrote:

> On Wed, Dec 17, 2008 at 7:34 PM, Andrew Paprocki <andrew@ishiboo.com> wrote:
> > I see two problems with the i8k module and the Dell XPS M1530. First,
> > the laptop is not detected. Second, even if it is detected, the module
> > prints that it is unable to get the SMM BIOS version even though the
> > module appears to be working:
> 
> It appears that the Dell Vostro & Precision series have the same issue
> and the driver was never updated for those as well. Patches were
> submitted back in 2007-11 and 2008-04 respectively:
> 
> http://marc.info/?l=linux-kernel&m=119401935026583&w=2
> http://marc.info/?l=linux-kernel&m=120822526223412&w=2

Thanks, I picked up all three (much to various people's surprise, I expect).

> The same message prints for (at least one of) those as well:
> 
> i8k: unable to get SMM BIOS version

hm.  But the driver works OK anyway?
