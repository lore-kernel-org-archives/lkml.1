Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbYFDIDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbYFDIDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 04:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbYFDIC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 04:02:57 -0400
Received: from aun.it.uu.se ([130.238.12.36]:37020 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbYFDIC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 04:02:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18502.19495.626780.26511@harpo.it.uu.se>
Date: Wed, 4 Jun 2008 10:02:47 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Rainer Koenig <Rainer.Koenig@fujitsu-siemens.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Who can backport the AHCI driver to older kernels
In-Reply-To: <200806040650.12683.Rainer.Koenig@fujitsu-siemens.com>
References: <200806031247.42046.Rainer.Koenig@fujitsu-siemens.com>
	<200806031352.31940.elendil@planet.nl>
	<18501.13296.224958.291840@harpo.it.uu.se>
	<200806040650.12683.Rainer.Koenig@fujitsu-siemens.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rainer Koenig writes:
 > Hi Mikael,
 > 
 > Am Dienstag, 3. Juni 2008 14:07 schrieb Mikael Pettersson:
 > > Redhat seems to regularly backport the entire libata layer
 > > to at least 2.6.18 (RHEL5) and maybe also 2.6.9 (RHEL4).
 > 
 > Yes indeed we get perfect support from both Red Hat and SUSE for their 
 > enterprise level distribution. I already got a driver kit for the 
 > SLES10 kernel. The problem is that the targeted market is not willing
 > to use enterprise level (which means spend money for subscription) 
 > distros. They go for the "free" (as in free beer) distros and suffer 
 > from missing drivers. 

a) the RHEL sources are freely available
b) lots of people and organisations grab, tweak, and build them
   (including I might add many HPC sites using perfctr)
c) there's at least one no-cost binary redistribution (CentOS)
d) it's also easy to combine e.g. FC user-space with a
   self-compiled RHEL kernel, at least as long as they're
   closely matched (e.g. FC6 + RHEL5 is fine)
   (heck, I've even run FC6 on top of a SLES10.1 kernel)

So everything's that's needed is out there.
