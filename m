Return-Path: <linux-kernel-owner+w=401wt.eu-S1752901AbZGXNcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbZGXNcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 09:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbZGXNb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 09:31:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:55285 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZGXNb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 09:31:59 -0400
Subject: Re: report a bug about sched_rt
From: Peter Zijlstra <peterz@infradead.org>
To: sen wang <wangsen.linux@gmail.com>
Cc: mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com>
References: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com>
	 <1248437670.6987.26.camel@twins>
	 <454c71700907240604h4673f117j8ed58b9f2ee54798@mail.gmail.com>
	 <1248441290.6987.52.camel@twins>
	 <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 24 Jul 2009 15:33:35 +0200
Message-Id: <1248442415.6987.56.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-24 at 21:26 +0800, sen wang wrote:
> don't tell me what theory. don't be so doctrinairism! OK?
> If cpu is free and there is a running state task,how can you scdedule
> idle task up?
> I tell you again:we are not talking about a bandwidth of 100% for RT!
> Bug lies in the bandwidth of (100- X)%.(X<100)
> even in the time of 100-X,if there is a rt task, you should not idle()
> the system.

*sigh*

Yes we should. I appreciate that you might assume otherwise, but you're
wrong. Suppose you have two competing bandwidth groups, which one will
run over, to what purpose?

Also, your next top post will go to /dev/null.
