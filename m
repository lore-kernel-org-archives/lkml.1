Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbZCTPB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbZCTPB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 11:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbZCTPBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 11:01:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37565 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753585AbZCTPBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 11:01:19 -0400
Date: Fri, 20 Mar 2009 15:00:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Daniel Stone <daniel@fooishbar.org>,
       Sindhudweep Sarkar <sindhudweep.sarkar@gmail.com>,
       David Airlie <airlied@linux.ie>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core
 changes
Message-ID: <20090320150032.31ef6a51@lxorguk.ukuu.org.uk>
In-Reply-To: <20090320145340.GA11347@kroah.com>
References: <20090319040809.GA29249@kroah.com>
	<6c046ab30903190903r298a0334n939e64403b8aeda6@mail.gmail.com>
	<20090319162719.GB32078@kroah.com>
	<20090320060823.GF32194@fooishbar.org>
	<20090320145340.GA11347@kroah.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > By the same logic, would you support including the proprietary NVIDIA
> > driver while we wait for Nouveau to catch up?
> 
> The license of the NVIDIA driver does not allow that to even be a
> possibility.

I'm not convinced this is any different. If you accept the 3D changes you
step into a dangerous world of estoppel and since it has many
rightsholders also the wonderful world of contributory infringement. It
really really needs lawyers to look into it.

Now the other way to do it that might be more productive and simpler
would be to rip all the 3D crap out of that driver and just include the
minimum needed 2D bits for the open source X driver. Makes the code
smaller and cleaner, avoids an legal questions and lets people get on
with real work.

