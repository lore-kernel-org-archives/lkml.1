Return-Path: <linux-kernel-owner+w=401wt.eu-S1759491AbXKTOgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbXKTOgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 09:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757811AbXKTOgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 09:36:21 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:38422 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270AbXKTOgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 09:36:20 -0500
Message-ID: <4742EFBE.6030407@keyaccess.nl>
Date: Tue, 20 Nov 2007 15:31:26 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: trenn@suse.de
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>, akpm <akpm@linux-foundation.org>,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 2/3] PNP cleanups - Unify the pnp macros to access	resources
 in the pnp resource table
References: <1195552283.23700.166.camel@queen.suse.de>	 <20071120123102.03bdaa67@the-village.bc.nu> <1195568360.23700.202.camel@queen.suse.de>
In-Reply-To: <1195568360.23700.202.camel@queen.suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-11-07 15:19, Thomas Renninger wrote:

> At the end is some example code how things could get even more cleaned
> up. It shows how I think pnp layer and one example driver would get
> adjusted. There are not that much drivers making use of
> pnp_resource_change...

The ALSA ISA-PnP drivers do in what I personally consider a bad layering 
violation. Brought up not doing that a while ago on alsa-devel, but no 
discussion ensued. If the PnP maintainer(s) agree with me though, I'd be 
more than happy to rip all of that out of ALSA.

(added alsa-devel)

Rene.
