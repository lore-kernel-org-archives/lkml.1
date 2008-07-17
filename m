Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbYGQPpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbYGQPpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbYGQPph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:45:37 -0400
Received: from gw.goop.org ([64.81.55.164]:39081 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498AbYGQPpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:45:36 -0400
Message-ID: <487F6913.2000602@goop.org>
Date: Thu, 17 Jul 2008 08:45:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Alex Nixon (Intern)" <Alex.Nixon@eu.citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: Large increase in context switch rate
References: <487E43D9.7080703@goop.org> <1216286250.5232.67.camel@twins> <487F5F15.4050208@goop.org> <0E902970173AF84089673FA54B7FE78A32906B@lonpexch01.citrite.net>
In-Reply-To: <0E902970173AF84089673FA54B7FE78A32906B@lonpexch01.citrite.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Nixon (Intern) wrote:
> Yeah I've checked - the number of context switches seems to be around
> 60k regardless of whether CONFIG_PARAVIRT is switched on, and regardless
> of whether it's running in domu or native (-j4 on dual core)
>   

OK, just to be sure we're talking about the same thing, is kernbench 
displaying the context switch *rate*, or the total number of context 
switches during the build?

Peter is looking at vmstat, which is showing cs/sec.

    J
