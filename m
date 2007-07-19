Return-Path: <linux-kernel-owner+w=401wt.eu-S1763542AbXGSXJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763542AbXGSXJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 19:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755891AbXGSXJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 19:09:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:58200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755581AbXGSXJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 19:09:08 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Arthur Jones <arthur.jones@qlogic.com>
Subject: Re: build fix for x86_64...
Date: Fri, 20 Jul 2007 01:09:01 +0200
User-Agent: KMail/1.9.6
Cc: Vasily Tarasov <vtaras@openvz.org>, linux-kernel@vger.kernel.org,
       "Luck, Tony" <tony.luck@intel.com>, Jan Kara <jack@ucw.cz>,
       linux-arch@vger.kernel.org
References: <20070719222411.GO12489@bauxite.pathscale.com>
In-Reply-To: <20070719222411.GO12489@bauxite.pathscale.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707200109.02039.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 July 2007 00:24:11 Arthur Jones wrote:
> hi vasily,
> 
> commit b716395e2b8e450e294537de0c91476ded2f0395
> breaks the build for x86_64 (and ia64 too, i guess) if
> CONFIG_COMPAT is not turned on.  here is a patch, which
> i think is more complete than the previous one posted
> to LKML by Doug Chapman (which only fixes ia64, i think).
> it lets the build continue, but i have no idea if it's
> correct or not..

Looks good,

Tony, perhaps it would make sense to define some common CONFIG
for COMPAT_FOR_U64_ALIGNMENT longer term to make the #ifs for this
case a little less ugly.

-Andi

