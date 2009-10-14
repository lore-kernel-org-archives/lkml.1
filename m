Return-Path: <linux-kernel-owner+w=401wt.eu-S1760905AbZJNVdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905AbZJNVdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 17:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760782AbZJNVde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 17:33:34 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:43457 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760774AbZJNVde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 17:33:34 -0400
Date: Wed, 14 Oct 2009 17:32:57 -0400
To: Frans Pop <elendil@planet.nl>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>, torvalds@linux-foundation.org,
       jeff.chua.linux@gmail.com, Valdis.Kletnieks@vt.edu, mangoo@wpkg.org,
       daniel.blueman@gmail.com, bstanoszek@comtime.com,
       dave@linux.vnet.ibm.com, hugh.dickins@tiscali.co.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       hugh@veritas.com
Subject: Re: 2.6.32-rc3: low mem - only 378MB on x86_32 with 64GB. Why?
Message-ID: <20091014213257.GA5498@csclub.uwaterloo.ca>
References: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com> <b6a2187b0910051715y4ee63503y148ba2d7e24cad8e@mail.gmail.com> <alpine.LFD.2.01.0910051727420.3432@localhost.localdomain> <alpine.LFD.2.01.0910051727420.3432@localhost.localdomain> <200910061106.33718.tvrtko.ursulin@sophos.com> <200910061301.39221.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910061301.39221.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 01:01:35PM +0200, Frans Pop wrote:
> Tvrtko Ursulin wrote:
> >> In fact, I wish more people did that, just so that we'd get better
> >> coverage of the 32-bit compat code. We occasionally find issues there,
> >> although I think it's getting rarer.
> > 
> > Maybe convince some distro to offer this setup as an option at least? I
> > always wondered why no one has, or maybe I missed it.
> 
> Debian has a 64-bit kernel for its 32-bit "i386" architecture (and also for 
> its 64-bit "amd64" architecture obviously):
> - for stable: http://packages.debian.org/lenny/linux-image-2.6.26-2-amd64
> - for unstable: http://packages.debian.org/sid/linux-image-2.6.30-2-amd64

I have been running that Debian setup for 5 years now.  It's great.
Other than 32 bit iptables not liking the 64bit kernel, I can't currently
recall any issues at any point.  Well and configure scripts often have to
be run with the 'linux32' wrapper to make them not try something stupid.

-- 
Len Sorensen
