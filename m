Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbYISXhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbYISXhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 19:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYISXhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 19:37:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60482 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbYISXhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 19:37:04 -0400
Message-ID: <48D436A7.4010604@zytor.com>
Date: Fri, 19 Sep 2008 16:32:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v3)
References: <48D21BA3.76E4.0078.0@novell.com> <20080918071852.GA7639@elte.hu> <20080918091003.GA3751@elte.hu> <48D23BF6.76E4.0078.0@novell.com> <20080918095710.GA11633@elte.hu> <20080918112018.GA456@elte.hu> <48D25E87.76E4.0078.0@novell.com> <48D29741.4070404@goop.org> <48D37FDA.76E4.0078.0@novell.com> <48D41DAF.6020804@goop.org>
In-Reply-To: <48D41DAF.6020804@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> CONFIG_RESOURCES_64BIT was removed, so testing for it makes no sense. 
> (Not being able to distinguish between non-existent and unset config
> variables is an outstanding Kconfig problem.)
> 

IMO we should change it to use #if instead of #ifdef.  The transition 
problem has been discussed elsewhere.

	-hpa

