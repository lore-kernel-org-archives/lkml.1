Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbYAXWAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbYAXWAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbYAXV74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:59:56 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:46592 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404AbYAXV7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:59:55 -0500
Date: Thu, 24 Jan 2008 23:00:05 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild: Preparing for merge window
Message-ID: <20080124220005.GB4204@uranus.ravnborg.org>
References: <20080124215813.GA4204@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080124215813.GA4204@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 10:58:13PM +0100, Sam Ravnborg wrote:
> The following is the list of patches queued up for the merge window at the moment.
> I have during the last week done several modpost changes to make section ismatch
> warnings more reliable and I am happy with the modified modpost code now.
> 
> The warnings generated will if CONFIG_DEBUG_SECTION_MISMATCH=y be verbose
> so it better guides the developer how to fix the warning.
> 
> Other patches of interest:
> 
> - We now have separate sections for all init/exit annotations
> - We have restarted getting kconfig globalized, pending is widechar support
> - Support for modules.order to tell in what order to load modules
> - lots of small fixes/enhancements
> 
> The diffstat say that we touch a lot of files.
> This is due to the following changes (mainly):
> - consolidation touching all .lds.S files
> - removal ofstale comment about make dep
> - removal of obsolete __attribute_used__
> - removal of TOPDIR
> 
> Patches will follow for review.

Patches will be sent to linux-kbuild only.

	Sam
