Return-Path: <linux-kernel-owner+w=401wt.eu-S934534AbYBOBY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934534AbYBOBY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 20:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934078AbYBOBYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 20:24:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934044AbYBOBYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 20:24:37 -0500
Message-ID: <47B4E9CB.3090708@redhat.com>
Date: Thu, 14 Feb 2008 20:24:27 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next build status
References: <20080215114253.ddf3f929.sfr@canb.auug.org.au>
In-Reply-To: <20080215114253.ddf3f929.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Initial status can be seen here
> http://kisskb.ellerman.id.au/kisskb/branch/9/ (I hope to make a better
> URL soon).  Suggestions for more compiler/config combinations are
> welcome, but we can't necessarily commit to fulfilling all you
> wishes.  :-)
> 

i386 allmodconfig please.

Also, I highly recommend adding some randconfig builds, at least one 32-bit arch 
and one 64-bit arch.  Any given randconfig build is not particularly likely to 
catch bugs that would be missed elsewhere, but doing them daily for two months 
will catch a lot of things before they get released.  The catch, of course, is 
that you have to actually save the .config for this to be useful, which might 
require a slight modification to your scripts.

	-- Chris
