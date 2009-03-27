Return-Path: <linux-kernel-owner+w=401wt.eu-S933836AbZC0Awi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836AbZC0Awi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762889AbZC0Avh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:51:37 -0400
Received: from tundra.namei.org ([65.99.196.166]:1647 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933783AbZC0Avf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:51:35 -0400
Date: Fri, 27 Mar 2009 11:51:31 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Pavel Machek <pavel@ucw.cz>
cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: TOMOYO in linux-next
In-Reply-To: <20090327003040.GH29836@elf.ucw.cz>
Message-ID: <alpine.LRH.2.00.0903271146560.11179@tundra.namei.org>
References: <20090326215031.GD29836@elf.ucw.cz> <alpine.LRH.2.00.0903271102240.7492@tundra.namei.org> <20090327003040.GH29836@elf.ucw.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009, Pavel Machek wrote:

> > > Security should be doable
> > > without making shell-like glob matching...
> > 
> > The TOMOYO developers have already responded to your feedback on this 
> > issue.  It's also an inherent aspect of pathname security, an issue which 
> > has been resolved in favour of inclusion in the kernel.
> 
> Do you have any references? My memory claims otherwise on this.

Al Viro merged the LSM pathname hooks.

> > As for the rest of the feedback, please work with the developers to fix 
> > any bugs or lack of documentation.
> 
> Which brings a question: given that kernel<->user interface is
> undocumented, how was this reviewed?

By 15 iterative posts to lkml and LSM, with extensive discussion and 
feedback, as well as presentations by the TOMOYO developers at various 
conferences around the world.



- James
-- 
James Morris
<jmorris@namei.org>
