Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbZKSAlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbZKSAlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 19:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942AbZKSAla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 19:41:30 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:55353 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757092AbZKSAlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 19:41:21 -0500
Date: Wed, 18 Nov 2009 19:41:27 -0500
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Valdis.Kletnieks@vt.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Matteo Croce <technoboy85@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091119004127.GJ15157@caffeine.csclub.uwaterloo.ca>
References: <20091113212148.5cb829d4@lxorguk.ukuu.org.uk> <20091116175006.GA15157@caffeine.csclub.uwaterloo.ca> <20091117115929.4ba23c49@lxorguk.ukuu.org.uk> <7332.1258476527@turing-police.cc.vt.edu> <20091117172515.GI15159@caffeine.csclub.uwaterloo.ca> <4B02DE4E.4070504@zytor.com> <20091117183357.GH15157@caffeine.csclub.uwaterloo.ca> <20091118202109.GJ15159@caffeine.csclub.uwaterloo.ca> <4B046038.4040608@zytor.com> <20091118211122.GI15157@caffeine.csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118211122.GI15157@caffeine.csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 04:11:22PM -0500, Lennart Sorensen wrote:
> Strange how it says that for every value I have tried so far.  Makes me
> wonder if there is a register somewhere that disables MSR support.
> I did find a lockout value but I can't read that one either (which says
> it is always readable).

I tried doing rdmsr on 0x1810 from grub, and it faults too.  cpuid says
MSRs are supported, I just can't find any that work.

-- 
Len Sorensen
