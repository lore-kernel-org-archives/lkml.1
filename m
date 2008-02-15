Return-Path: <linux-kernel-owner+w=401wt.eu-S1765718AbYBOMsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765718AbYBOMsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 07:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbYBOMsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 07:48:02 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:36032 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821AbYBOMsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 07:48:00 -0500
Date: Fri, 15 Feb 2008 13:46:43 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: allow alternative hook script dir in .deb packages
Message-ID: <20080215124643.GB1178@uranus.ravnborg.org>
References: <200802131118.11413.elendil@planet.nl> <200802131242.27907.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802131242.27907.elendil@planet.nl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 12:42:18PM +0100, Frans Pop wrote:
> From: Frans Pop <elendil@planet.nl>
>     
> Hook scripts in the default directory /etc/kernel are also
> executed by packages created using make-kpkg (including official
> Debian kernels). Allow to specify an alternative hook scripts
> directory by exporting the environment variable KERNELDEBHOOKDIR
> so that this can be avoided.

Do we have similar hook scripts for rpm for instance?
If we have then a deb specific solution is not acceptable,
we would need something that works across all packages.

Does this btw have to be an environment variable?
Why not make it a config option?

	Sam
