Return-Path: <linux-kernel-owner+w=401wt.eu-S936855AbXGNBbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936855AbXGNBbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764968AbXGNB1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:27:33 -0400
Received: from gw.goop.org ([64.81.55.164]:56909 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765318AbXGNB1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:27:31 -0400
Message-ID: <4698264B.7080406@goop.org>
Date: Fri, 13 Jul 2007 18:26:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] Use --build-id ld option
References: <4695B28E.2020603@goop.org> <20070712062458.6B2BD4D0489@magilla.localdomain> <20070714012301.GB3565@stusta.de>
In-Reply-To: <20070714012301.GB3565@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> But note that twice compiling a kernel with the same .config will result 
> in a different one.

Is that true even if you reset the .version counter each time?  I'm 
thinking of product build systems, in which they value being able to 
reproduce the same build (ideally, bit for bit).

    J
