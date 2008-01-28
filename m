Return-Path: <linux-kernel-owner+w=401wt.eu-S1762647AbYA1Wjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762647AbYA1Wjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbYA1WjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:39:20 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:41573 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbYA1WjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:39:19 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] security/selinux/netlabel.c: fix double free
Date: Mon, 28 Jan 2008 17:39:12 -0500
User-Agent: KMail/1.9.7
Cc: James Morris <jmorris@namei.org>, sds@tycho.nsa.gov, eparis@parisplace.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080128220938.GH8767@does.not.exist> <200801281723.46273.paul.moore@hp.com> <20080128223540.GN8767@does.not.exist>
In-Reply-To: <20080128223540.GN8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281739.12841.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008 5:35:40 pm Adrian Bunk wrote:
> On Mon, Jan 28, 2008 at 05:23:46PM -0500, Paul Moore wrote:
> > Thanks for finding this mistake, however, I'd rather see it fixed
> > by removing the netlbl_secattr_destroy() call in
> > security_netlbl_sid_to_secattr() as it really shouldn't be there
> > anymore.  We moved the matching _init() call into
> > selinux_netlbl_sock_setsid() and I'd like to see the _init() and
> > _destroy() calls done in the same function.  I can push a revised
> > patch for this if you would prefer, otherwise I'll be happy to ack
> > an updated version ...
>
> doing the patch is trivial but you are able to write a better
> changelog for it - just push a revised patch.

Will do, thanks.

-- 
paul moore
linux security @ hp
