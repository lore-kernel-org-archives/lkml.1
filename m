Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbYLaBM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbYLaBM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 20:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYLaBMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 20:12:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45278 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbYLaBMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 20:12:19 -0500
Date: Wed, 31 Dec 2008 02:25:42 +0100
From: Andi Kleen <andi@firstfloor.org>
To: david@lang.hm
Cc: Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
Message-ID: <20081231012542.GP496@one.firstfloor.org>
References: <alpine.DEB.1.10.0812301416550.16847@asgard.lang.hm> <87k59hur5f.fsf@basil.nowhere.org> <alpine.DEB.1.10.0812301737320.16936@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812301737320.16936@asgard.lang.hm>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 05:39:29PM -0800, david@lang.hm wrote:
> On Wed, 31 Dec 2008, Andi Kleen wrote:
> 
> >david@lang.hm writes:
> >>
> >>doing a grep through System.map for the address that appears in the
> >>error returns nothing
> >
> >This might be obvious, but you can't grep directly for these addresses
> >because System.map contains the starting addresses of functions only
> >and normally the reported address is somewhere in the middle of a
> >function. So you instead have to look for the highest number lower or equal
> >the address from the exception.
> 
> thanks, this was not obvious to me
> 
> the -2 error maps to

You should also boot with earlyprintk=vga to get more context.

-Andi
