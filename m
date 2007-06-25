Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbXFYVOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbXFYVOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbXFYVOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:14:33 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:38541 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbXFYVOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:14:32 -0400
Date: Mon, 25 Jun 2007 17:14:28 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: Andreas Gruenbacher <agruen@suse.de>
cc: Chris Wright <chrisw@sous-sol.org>, linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH try #2] security: Convert LSM into a static interface
In-Reply-To: <200706252237.59226.agruen@suse.de>
Message-ID: <Line.LNX.4.64.0706251712570.24003@localhost.localdomain>
References: <20070617135239.GA17689@sergelap> <20070624220903.GB3723@sequoia.sous-sol.org>
 <Line.LNX.4.64.0706250031350.15974@localhost.localdomain>
 <200706252237.59226.agruen@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007, Andreas Gruenbacher wrote:

> It's useful for some LSMs to be modular, and LSMs which are y/n options won't 
> have any security architecture issues with unloading at all. 

Which LSMs?  Upstream, there are SELinux and capabilty, and they're not 
safe as loadable modules.

> The mere fact 
> that SELinux cannot be built as a module is a rather weak argument for 
> disabling LSM modules as a whole, so  please don't.

That's not the argument.  Please review the thread.


- James
-- 
James Morris
<jmorris@namei.org>
