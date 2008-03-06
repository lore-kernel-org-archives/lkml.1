Return-Path: <linux-kernel-owner+w=401wt.eu-S934655AbYCFQaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934655AbYCFQaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 11:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764340AbYCFQ3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 11:29:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:3080 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763931AbYCFQ3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 11:29:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=EAbrsBlk95xnOl4xQySsnsKVTl9vpqd8COnQ2gJoTePLvWnUf9p0l5nThPVr5jZDZsnyLb1CjudfVIMZtXYk6YpH/sqXPzRe38xTj68i1gNXzUBYB6o6iVHDVGMgWlyrafzzY1RV0G6T6WWVqglZYtdI84qlaMSvOtqwZp3B21w=
Message-ID: <47D01BF8.2010805@gnu.org>
Date: Thu, 06 Mar 2008 17:29:44 +0100
From: Paolo Bonzini <bonzini@gnu.org>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
Newsgroups: gmane.comp.gcc.devel,gmane.linux.kernel
To: Robert Dewar <dewar@adacore.com>
CC: NightStrike <nightstrike@gmail.com>, Olivier Galibert <galibert@pobox.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Chris Lattner <clattner@apple.com>,
       Michael Matz <matz@suse.de>,
       Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Jan Hubicka <hubicka@ucw.cz>,
       Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
  flag
References: <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de> 	 <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com> 	 <47CF11D6.7070901@zytor.com> 	 <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com> 	 <Pine.LNX.4.64.0803052258530.20583@wotan.suse.de> 	 <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com> 	 <47CF3F09.4080606@zytor.com> 	 <578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com> 	 <47CF44E7.3020106@zytor.com> <20080306135139.GA5236@dspnet.fr.eu.org> <b609cb3b0803060737xa0c3c0byb51d51af797eb81f@mail.gmail.com> <47D01457.30001@adacore.com>
In-Reply-To: <47D01457.30001@adacore.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Another story, the sad story of the intel chip (I think it was
> the 80188) where Intel made use of Int 5, which was documented
> as reserved. Unfortunately, Microsoft/IBM had used this for
> print screen or some such. Intel was absolutely right that
> their documentation was clear and it was wrong to have used
> these interrupts .. but the result was a warehouse of unused
> chips.

Not really.  Just, no one used the BOUND instruction.  All computers 
running DOS (Intel, AMD, even the old NEC V20/V30 chips) still connect 
INT 5 to Print Screen.

Paolo
