Return-Path: <linux-kernel-owner+w=401wt.eu-S1765040AbXILTqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765040AbXILTqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 15:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763636AbXILTqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 15:46:39 -0400
Received: from h3mxr01.htp-tel.de ([81.14.243.49]:36890 "EHLO
	H3MXR01.htp-tel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764038AbXILTqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 15:46:38 -0400
Message-ID: <46E84208.1050903@leemhuis.info>
Date: Wed, 12 Sep 2007 21:46:16 +0200
From: Thorsten Leemhuis <fedora@leemhuis.info>
User-Agent: Thunderbird 2.0.0.6 (X11/20070910)
MIME-Version: 1.0
To: Bernd Petrovitsch <bernd@firmix.at>
CC: Dan Stromberg <dstromberglists@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Building a kernel-source RPM (not a kernel RPM)?
References: <pan.2007.09.12.16.13.41.195991@gmail.com>	 <1189616966.31502.75.camel@tara.firmix.at>	 <pan.2007.09.12.17.30.59.597440@gmail.com> <1189620186.31502.96.camel@tara.firmix.at>
In-Reply-To: <1189620186.31502.96.camel@tara.firmix.at>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.09.2007 20:03, Bernd Petrovitsch wrote:
> On Wed, 2007-09-12 at 10:31 -0700, Dan Stromberg wrote:
>> On Wed, 12 Sep 2007 19:09:26 +0200, Bernd Petrovitsch wrote:
> [...]
>>> Fedora BTW abandoned kernel-source* and they have now a website with a
>>> description
>>> how to produce a configured kernel source tree (e.g. for out-of-tree
>>> modules).

That explanation is IMHO a bit misleading. Fedora ships kernel-devel
packages for all their kernels. Those contain everything from the
source-tree that's needed to build out-of-tree modules -- Makefiles for
example, but no real sources.

Well, to be more precise: that is enought for out-of-tree modules that
get shipped with proper Makefiles/Layout, which is the case for nearly
every external module these days. The "website with a description how to
produce a configured kernel source tree" exists as well, for people that
want to build kernels the way the Fedora builds them, but want to apply
additional patches/other sources.

>> So this is as smooth as producing kernel-source RPM's gets?
> I had no problems with the kernel-source.*.rpm approach.

I think the Fedora approach has many benefits -- I always wondered why
it never went upstream like a "make install_develstuff" that install all
the needed bits to
  /lib/modules/$(uname -r)/build/

CU
knurd


