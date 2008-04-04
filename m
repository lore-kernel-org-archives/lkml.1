Return-Path: <linux-kernel-owner+w=401wt.eu-S1756959AbYDDMF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959AbYDDMF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 08:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbYDDMFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:05:46 -0400
Received: from mail.hevs.ch ([153.109.23.10]:51555 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbYDDMFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:05:46 -0400
X-Greylist: delayed 1218 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Apr 2008 08:05:45 EDT
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: module parameters versus kernel command line
Date: Fri, 4 Apr 2008 12:45:37 +0100
User-Agent: KMail/1.9.7
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Tom Horsley <tom.horsley@ccur.com>,
       linux-kernel@vger.kernel.org
References: <20080403090053.56f243df@tomh> <20080403091444.827d954a.randy.dunlap@oracle.com> <200804040909.28983.rusty@rustcorp.com.au>
In-Reply-To: <200804040909.28983.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804041345.38482.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 April 2008, Rusty Russell wrote:
...
> The second is that users might be surprised when they take 
> the 'usbcore.blinkenlights' line out of their modprobe config file and it 
> still applies.  Most users use everything-is-a-module distributions.

Why don't do it in user space (let insmod/modprobe parse /proc/cmdline)?
1. Users won't be surprised after looking at the new man pages:)
2. it will work with older kernel

The warning problem is more complicated to fix.

Regards

Marc
