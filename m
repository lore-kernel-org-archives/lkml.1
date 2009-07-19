Return-Path: <linux-kernel-owner+w=401wt.eu-S1751976AbZGSGsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbZGSGsH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 02:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbZGSGsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 02:48:05 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:53776
	"EHLO QMTA15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278AbZGSGsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 02:48:05 -0400
Subject: Re: [RFC][PATCH] Introduce CLOCK_REALTIME_COARSE
From: Nicholas Miell <nmiell@comcast.net>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Chris Snook <chris.snook@gmail.com>, john stultz <johnstul@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@tglx.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       nikolag@ca.ibm.com, Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <20090718231429.7ddea95f@infradead.org>
References: <1247873945.8334.67.camel@localhost.localdomain>
	 <13a12eea0907182000v654e38a5l265ae5bdadb1a175@mail.gmail.com>
	 <20090718231429.7ddea95f@infradead.org>
Content-Type: text/plain
Date: Sat, 18 Jul 2009 23:48:01 -0700
Message-Id: <1247986081.9351.21.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-18 at 23:14 -0700, Arjan van de Ven wrote:
> it's on x86.. likely/unlikely don't impact the CPU (since there are no
> "ignore the branch predictor" hints), only the code placement.....

But code placement does affect branch prediction (e.g. the Pentium 4
static predictor assumes backward branches are taken, recent AMD
processors prefer you to arrange code such that conditional branches are
not taken, etc.)

-- 
Nicholas Miell <nmiell@comcast.net>

