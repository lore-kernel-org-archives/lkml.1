Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbXL0S1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbXL0S1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 13:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbXL0S1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 13:27:46 -0500
Received: from mail.gmx.net ([213.165.64.20]:40712 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752105AbXL0S1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 13:27:45 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/bSrpQSqLbUrMoewM0PfLB9zVOHBmtwB7ipQkZ85
	oIx7QE6p2UEa99
Subject: Re: [patch?] s2ram + P4 + tsc = annoyance
From: Mike Galbraith <efault@gmx.de>
To: Robert Hancock <hancockr@shaw.ca>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4773EA58.2040605@shaw.ca>
References: <fa./Gg6lFn4vN7sfhp2nE3LSMDm0q4@ifi.uio.no>
	 <4773EA58.2040605@shaw.ca>
Content-Type: text/plain
Date: Thu, 27 Dec 2007 19:27:43 +0100
Message-Id: <1198780063.4425.59.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-27 at 12:09 -0600, Robert Hancock wrote:

> Are we missing some logic to resync the TSCs after resume, or something?

They used to be forcibly synchronized during boot, but it seems that was
dropped in 2.6.21.

	-Mike

