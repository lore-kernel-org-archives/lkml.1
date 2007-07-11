Return-Path: <linux-kernel-owner+w=401wt.eu-S1765281AbXGKPPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765281AbXGKPPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 11:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763428AbXGKPPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 11:15:10 -0400
Received: from waste.org ([66.93.16.53]:55853 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761193AbXGKPPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 11:15:09 -0400
Date: Wed, 11 Jul 2007 10:14:42 -0500
From: Matt Mackall <mpm@selenic.com>
To: Pavel Emelianov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 0/16] Pid namespaces
Message-ID: <20070711151442.GA11115@waste.org>
References: <468DF6F7.1010906@openvz.org> <20070711011652.GV11166@waste.org> <46947B06.8030605@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46947B06.8030605@openvz.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 10:39:02AM +0400, Pavel Emelianov wrote:
> Matt Mackall wrote:
> > On Fri, Jul 06, 2007 at 12:01:59PM +0400, Pavel Emelianov wrote:
> >> This is "submition for inclusion" of hierarchical, not kconfig
> >> configurable, zero overheaded ;) pid namespaces.
> > 
> > How big is it?
> 
> Summary: 50 files changed, 877 insertions, 241 deletions. Besides,
> each patch has a diffstat output in the letter.

No, how much impact does it have on the compiled kernel's size?

> > Do I want it on my cell phone or on my wireless router?
> 
> I do not know, but those who do not need the namespaces at
> all won't even notice its presence. I tried to do such.

It seems likely that something that adds a net 600 lines of code will
have a noticeable footprint.

-- 
Mathematics is the supreme nostalgia of our time.
