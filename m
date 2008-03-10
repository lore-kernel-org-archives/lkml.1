Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbYCJXil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbYCJXil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbYCJXid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:38:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164AbYCJXic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:38:32 -0400
Date: Mon, 10 Mar 2008 16:37:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andres Salomon <dilinger@queued.net>, adaplas@gmail.com,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       info-linux@geode.amd.com, jordan.crouse@amd.com,
       samuel.thibault@ens-lyon.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 6/6] PM/FB/gxfb: add config option that allows disabling
 of VT switch during suspend
Message-Id: <20080310163744.5f6a04b8.akpm@linux-foundation.org>
In-Reply-To: <200803102328.19985.rjw@sisk.pl>
References: <20080308204927.73afa56c@ephemeral>
	<20080310145118.adb0cf1e.akpm@linux-foundation.org>
	<20080310181446.2fb85eea@ephemeral>
	<200803102328.19985.rjw@sisk.pl>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 23:28:18 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > > > If so, that means extra #ifdef's sprinkled throughout the code.  Note
> > > > that most framebuffer drivers won't be supporting this, and those that
> > > > do will almost certainly always want vt switching turned off..
> > > > 
> > > 
> > > I don't think you need any ifdefs or config options at all, do you?  Just
> > > add a new module parameter to this driver and some little interface into
> > > the PM core which allows the driver to set no_vt_switch?
> > > 
> > 
> > That's a possibility, but doesn't adding hooks into PM core for two
> > drivers (lxfb and gxfb) seems like overkill?  I also don't really see
> > anyone needing to switch back and forth between VT_SWITCH and
> > NO_VT_SWITCH other than to work around possible bugs in the register
> > save/restore code..
> 
> FWIW, I prefer the original .config option idea.

Please explain your reasoning?
