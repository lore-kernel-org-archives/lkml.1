Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbXFPBlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbXFPBlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 21:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757689AbXFPBlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 21:41:07 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:55041 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360AbXFPBlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 21:41:06 -0400
Date: Fri, 15 Jun 2007 21:41:01 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: david@lang.hm
cc: Greg KH <greg@kroah.com>, Crispin Cowan <crispin@novell.com>,
       Pavel Machek <pavel@ucw.cz>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <Pine.LNX.4.64.0706151656170.12349@asgard.lang.hm>
Message-ID: <Line.LNX.4.64.0706152122520.29737@localhost.localdomain>
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de>
 <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com>
 <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz>
 <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com>
 <20070615234925.GB15056@kroah.com> <Pine.LNX.4.64.0706151656170.12349@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007, david@lang.hm wrote:

> on the contrary, useing 'mv' is by far the cleanest way to do this.
> 
> mv htdocs htdocs.old;mv htdocs.new htdocs
> 
> this makes two atomic changes to the filesystem, but can generate thousands to
> millions of permission changes as a result.

OTOH, you've performed your labeling up front, and don't have to 
effectively relabel each file each time on each access, which is what 
you're really doing with pathname labeling.



- James
-- 
James Morris
<jmorris@namei.org>
