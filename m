Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbYIHPq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbYIHPq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbYIHPqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:46:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55967 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbYIHPqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:46:46 -0400
Date: Mon, 8 Sep 2008 17:50:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux@sandersweb.net,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Message-ID: <20080908155021.GN26079@one.firstfloor.org>
References: <200808311422.12525.linux@sandersweb.net> <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org> <20080908154535.GL26079@one.firstfloor.org> <48C54839.8050304@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C54839.8050304@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The help text is indeed out of date.  I did a patch yesterday to, among 
> other things, update it; I also want to verify that we are disabling all 
> options that can cause gcc or binutils to generate nopl's; I plan to 
> push it today.

You (or whoever did those changes) likely broke a lot of distribution setups 
subtly then. Hopefully the changes were worth that.

-Andi
-- 
ak@linux.intel.com
