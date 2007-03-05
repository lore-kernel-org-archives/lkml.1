Return-Path: <linux-kernel-owner+w=401wt.eu-S1751110AbXCEAsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110AbXCEAsy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 19:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbXCEAsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 19:48:54 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54225 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbXCEAsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 19:48:52 -0500
Date: Sun, 4 Mar 2007 16:45:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>, Adrian Bunk <bunk@stusta.de>
Cc: Johannes Berg <johannes@sipsolutions.net>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, yi.zhu@intel.com,
       jketreno@linux.intel.com,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Recent wireless breakage (ipw2200, iwconfig, NetworkManager)
Message-Id: <20070304164525.349f9589.akpm@linux-foundation.org>
In-Reply-To: <20070305002550.GI23311@waste.org>
References: <20070304220857.GH23311@waste.org>
	<1173051564.6131.13.camel@johannes.berg>
	<20070305002550.GI23311@waste.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Mar 2007 18:25:50 -0600 Matt Mackall <mpm@selenic.com> wrote:

> On Mon, Mar 05, 2007 at 12:39:24AM +0100, Johannes Berg wrote:
> > [adding linux-wireless to CC]
> > 
> > On Sun, 2007-03-04 at 16:08 -0600, Matt Mackall wrote:
> > > Recent kernels are having troubles with wireless for me. Two seemingly
> > > related problems:
> > 
> > I don't think they are related actually.
> > 
> > > a) NetworkManager seems oblivious to the existence of my IPW2200
> > 
> > This is due to the recent sysfs restructuring I think. IIRC the fix is
> > to upgrade hal to a current git version.
> 
> If that's the cause, the fix is to back out whatever was done to break
> userspace. Breaking userspace is not ok. Upgrading from 2.6.x to
> 2.6.x+1 should not entail replacing substantial parts of userspace,
> especially with NOT-EVEN-FRAKKING-RELEASED-YET CODE. 

yep.  Adrian, I think we should track this as a blocking regression, at
least until we've fully understood the implications and had the usual
arguments.
