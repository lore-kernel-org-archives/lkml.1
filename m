Return-Path: <linux-kernel-owner+w=401wt.eu-S1762282AbYBVGo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762282AbYBVGo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 01:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYBVGoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 01:44:16 -0500
Received: from ns.suse.de ([195.135.220.2]:54864 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbYBVGoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 01:44:15 -0500
Message-ID: <47BE6F2E.4080704@suse.de>
Date: Fri, 22 Feb 2008 07:43:58 +0100
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Thunderbird 2.0.0.9 (X11/20071114)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Feb 22
References: <20080222170421.9e17d143.sfr@canb.auug.org.au>
In-Reply-To: <20080222170421.9e17d143.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Stephen Rothwell schrieb:
> I am now including tarballs in
> http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/.

at least the bz2 tar i just looked at from that URL has a problem
with the prefix resulting to this toplevel extraction:

next-20080222arch
next-20080222block
...
next-20080222virt

So, i guess you just missed the trailing slash for the prefix
parameter of git archive?
(should be --prefix=next-20080222/ afaik)

Thanks,
Frank
