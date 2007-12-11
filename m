Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbXLKTqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbXLKTqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 14:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbXLKTqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 14:46:42 -0500
Received: from iriserv.iradimed.com ([72.242.190.170]:4309 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752113AbXLKTql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 14:46:41 -0500
Message-ID: <475EE920.7000108@cfl.rr.com>
Date: Tue, 11 Dec 2007 14:46:40 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Matt Mackall <mpm@selenic.com>,
       Marc Haber <mh+linux-kernel@zugschlus.de>,
       Eric Dumazet <dada1@cosmosbay.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       David.S.Mille@vax.1wt.eu
Illegal-Object: Syntax error in To: address found on vger.kernel.org:
	To:	David S.Mille
			^      ^-missing end of address
		 \-extraneous tokens in address
Illegal-Object: Syntax error in To: address found on vger.kernel.org:
	To:	David S.Mille
			^      ^-missing end of address
		 \-extraneous tokens in address
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <20071204164720.6e4dc2c4@the-village.bc.nu> <475599D6.4030008@cosmosbay.com> <20071205212646.GP17536@waste.org> <20071209124200.GA31147@torres.zugschlus.de> <20071209161605.G <20071211013414.GS17037@thunk.org>
In-Reply-To: <20071211013414.GS17037@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Dec 2007 19:46:53.0085 (UTC) FILETIME=[94186CD0:01C83C2E]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1023-15600.000
X-TM-AS-Result: No--13.737600-5.000000-2
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> Note that even paranoid applicatons should not be using /dev/random
> for session keys; again, /dev/random isn't magic, and entropy isn't
> unlimited. Instead, such an application should pull 16 bytes or so,
> and then use it to seed a cryptographic random number generator.

What good does using multiple levels of RNG do?  Why seed one RNG from 
another?  Wouldn't it be better to have just one RNG that everybody 
uses?  Doesn't the act of reading from the RNG add entropy to it, since 
no one reader has any idea how often and at what times other readers are 
stirring the pool?


