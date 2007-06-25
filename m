Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbXFYUis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbXFYUis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbXFYUik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:38:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:34184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbXFYUij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:38:39 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: James Morris <jmorris@namei.org>
Subject: Re: [PATCH try #2] security: Convert LSM into a static interface
Date: Mon, 25 Jun 2007 22:37:58 +0200
User-Agent: KMail/1.9.5
Cc: Chris Wright <chrisw@sous-sol.org>, linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
References: <20070617135239.GA17689@sergelap> <20070624220903.GB3723@sequoia.sous-sol.org> <Line.LNX.4.64.0706250031350.15974@localhost.localdomain>
In-Reply-To: <Line.LNX.4.64.0706250031350.15974@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706252237.59226.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 June 2007 06:33, James Morris wrote:
> Convert LSM into a static interface, as the ability to unload a security 
> module is not required by in-tree users and potentially complicates the 
> overall security architecture.

It's useful for some LSMs to be modular, and LSMs which are y/n options won't 
have any security architecture issues with unloading at all. The mere fact 
that SELinux cannot be built as a module is a rather weak argument for 
disabling LSM modules as a whole, so  please don't.

Thanks,
Andreas
