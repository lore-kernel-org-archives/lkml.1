Return-Path: <linux-kernel-owner+w=401wt.eu-S1762319AbYBPCYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762319AbYBPCYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 21:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbYBPCYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 21:24:06 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55346 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757941AbYBPCYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 21:24:05 -0500
Date: Sat, 16 Feb 2008 03:23:36 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: pci_device_id definition cleanups
Message-ID: <20080216022336.GA7740@uranus.ravnborg.org>
References: <1203117700.16761.9.camel@satguru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1203117700.16761.9.camel@satguru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 12:21:40AM +0100, Jonas Bonn wrote:
> I've done some work on cleaning up the definitions of pci_device_id to
> make them "static const" (where possible) and to make sure they go into
> __devinitconst.  There are about 350 changes of the type shown in the
> diff at the end of this mail.
> 
> ﻿All these changes are in my public GIT tree at:
> 
> git://www.southpole.se/~jonas/git/linux.git
> 
> (Based on 2.6.25-rc2)
> 
> In addition to these pci_device_id changes, there are a few changesets
> that move "const" data from __devinitdata to __devinitconst.
> 
> The tree above builds with both allmodconfig and allyesconfig.

Hi Jonas.

Can I ask you to try the same with ARCH=powerpc
(or alpha or ia64).
Becasue it is for these architectures we see issues with
defining data const.

	Sam
