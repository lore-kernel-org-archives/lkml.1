Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbYHSV3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbYHSV3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbYHSV24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:28:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752811AbYHSV2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:28:55 -0400
Date: Tue, 19 Aug 2008 14:28:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
In-Reply-To: <200808192315.48718.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0808191425050.3324@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808190952000.3324@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808191341150.3324@nehalem.linux-foundation.org> <20080819.140458.236030589.davem@davemloft.net> <200808192315.48718.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Aug 2008, Rafael J. Wysocki wrote:
> 
> FWIW, they fix the recent regression tracked as
> http://bugzilla.kernel.org/show_bug.cgi?id=11316 .

Yeah, and the real cause was apparently another commit that *ALSO* 
happened after the merge window!

Guys, you're making excuses for the problem.

The problem that triggered this bugus loopback change was commit 
e5a4a72d4f88f4389e9340d383ca67031d1b8536. Look at when that one was done. 

This is my whole _point_. The networking layer is doing development during 
the -rc window. And you guys are making excuses for it. Wake up, guys!

			Linus
