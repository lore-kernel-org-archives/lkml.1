Return-Path: <linux-kernel-owner+w=401wt.eu-S1752957AbZGXP7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbZGXP7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZGXP7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:59:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45029 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbZGXP7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:59:51 -0400
Subject: Re: report a bug about sched_rt
From: Peter Zijlstra <peterz@infradead.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: sen wang <wangsen.linux@gmail.com>, mingo@elte.hu,
       akpm@linux-foundation.org, kernel@kolivas.org, npiggin@suse.de,
       arjan@infradead.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090724154036.GG27755@shareable.org>
References: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com>
	 <1248437670.6987.26.camel@twins>
	 <454c71700907240604h4673f117j8ed58b9f2ee54798@mail.gmail.com>
	 <1248441290.6987.52.camel@twins>
	 <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com>
	 <1248442415.6987.56.camel@twins>
	 <454c71700907240644h7469e2a5sfcb57f202a2e184d@mail.gmail.com>
	 <1248443656.6987.61.camel@twins>
	 <454c71700907240724u76b970e5y5af0fc114cc92f83@mail.gmail.com>
	 <1248446910.6987.111.camel@twins>  <20090724154036.GG27755@shareable.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 24 Jul 2009 18:01:19 +0200
Message-Id: <1248451279.6987.138.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-24 at 16:40 +0100, Jamie Lokier wrote:
> Peter Zijlstra wrote:
> > If you're using the bandwidth throttle to control your RT tasks so as
> > not to starve your SCHED_OTHER tasks, then I will call your system ill
> > designed.
> 
> What mechanism should be used to avoid starving SCHED_OTHER tasks, in
> the event there are unforeseen bugs or unpredictable calculation times
> in an RT task?

For bugs the throttle works, like I said a well functioning system is
not supposed to hit the throttle, obviously a bug precludes the well
functioning qualification :-)

Unpredictable calculation times can be dealt with on the application
design level, for example using techniques such as outlined here:

  http://feanor.sssup.it/~faggioli/papers/OSPERT-2009-dlexception.pdf

These really are things you should know about before writing an RT
application ;-)
