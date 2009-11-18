Return-Path: <linux-kernel-owner+w=401wt.eu-S932506AbZKRVLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbZKRVLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 16:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbZKRVLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 16:11:17 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:42148 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756910AbZKRVLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 16:11:16 -0500
Date: Wed, 18 Nov 2009 16:11:22 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, Valdis.Kletnieks@vt.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Matteo Croce <technoboy85@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091118211122.GI15157@caffeine.csclub.uwaterloo.ca>
References: <20091113192412.GY15157@caffeine.csclub.uwaterloo.ca> <20091113212148.5cb829d4@lxorguk.ukuu.org.uk> <20091116175006.GA15157@caffeine.csclub.uwaterloo.ca> <20091117115929.4ba23c49@lxorguk.ukuu.org.uk> <7332.1258476527@turing-police.cc.vt.edu> <20091117172515.GI15159@caffeine.csclub.uwaterloo.ca> <4B02DE4E.4070504@zytor.com> <20091117183357.GH15157@caffeine.csclub.uwaterloo.ca> <20091118202109.GJ15159@caffeine.csclub.uwaterloo.ca> <4B046038.4040608@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B046038.4040608@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 12:59:36PM -0800, H. Peter Anvin wrote:
> On 11/18/2009 12:21 PM, Lennart Sorensen wrote:
> > 
> > OK, I added a bit of debuging print statements to msr.c and I find that
> > calling rdmsr 0x1810 returns error 0xfffffff2 (-14 that is).
> > 
> 
> What this means is the RDMSR instruction traps -- the CPU doesn't
> recognize this as a valid MSR.

Strange how it says that for every value I have tried so far.  Makes me
wonder if there is a register somewhere that disables MSR support.
I did find a lockout value but I can't read that one either (which says
it is always readable).

-- 
Len Sorensen
