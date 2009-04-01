Return-Path: <linux-kernel-owner+w=401wt.eu-S934302AbZDAU1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934302AbZDAU1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 16:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762260AbZDAU1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 16:27:23 -0400
Received: from baikonur.stro.at ([213.239.196.228]:40651 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758699AbZDAU1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 16:27:22 -0400
Date: Wed, 1 Apr 2009 22:24:31 +0200
From: maximilian attems <max@stro.at>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 0/5] Improve flexibility of deb-pkg target
Message-ID: <20090401202431.GE3901@baikonur.stro.at>
References: <200904012133.37387.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904012133.37387.elendil@planet.nl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 09:33:36PM +0200, Frans Pop wrote:
> Hi Sam,
> 
> This series of patches aims to make the deb-pkg target more flexible.
> I've been using these patches for the past year or so and they've greatly
> improved my workflow for kernel testing on 4 different architectures
> (2 cross-compiled).
> 
> The last 2 patches I've submitted before (in Feb. 2008) but were not
> applied as you had some questions. This new series has improved versions
> and I'll address your questions below.
> 
> [1/5] deb-pkg: minor general improvements in builddeb script
> [2/5] deb-pkg: fix 'file not found' error when building .deb package for arm
> 
> These first 2 patches are minor improvements and fixes.
> 
> [3/5] deb-pkg: pass Debian maintainer script parameters to packaging hook scripts
> 
> This allows to make hook scripts more specific differentiate their
> behavior for e.g. package installation, removal or upgrade. It's very
> much Debian specific.
> 
> [4/5] deb-pkg: allow to specify a custom revision for .deb packages
> 
> This has helped me to use a different versioning system for bisections
> than for "regular" builds. Note that this does not affect the kernel
> version (which is part of the package name), but only the version of
> the generated .deb package itself.
> 
> [5/5] deb-pkg: allow alternative hook scripts directory in .deb packages

argh none of those apply on top of those that i just sent in,
will nevertheless review them.
