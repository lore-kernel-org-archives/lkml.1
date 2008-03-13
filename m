Return-Path: <linux-kernel-owner+w=401wt.eu-S1752127AbYCMEs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbYCMEs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 00:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbYCMEsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 00:48:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbYCMEsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 00:48:16 -0400
Date: Wed, 12 Mar 2008 21:47:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Weiner <hannes@saeurebad.de>
cc: Dave Young <hidave.darkstar@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH -mm] do not check condition twice in WARN_ON_SECS
In-Reply-To: <87pru0oxyv.fsf@saeurebad.de>
Message-ID: <alpine.LFD.1.00.0803122147260.3557@woody.linux-foundation.org>
References: <20080312010933.GA2957@darkstar.te-china.tietoenator.com> <87pru0oxyv.fsf@saeurebad.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 Mar 2008, Johannes Weiner wrote:
> 
> What's wrong with:
> 
> #define WARN_ON_SECS(condition, secs) \
> 	WARN_ON(condition && __ratelimit(secs * HZ, 1))

Add parenthesis around the arguments, please.

		Linus
