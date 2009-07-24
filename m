Return-Path: <linux-kernel-owner+w=401wt.eu-S1752567AbZGXOqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbZGXOqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 10:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZGXOqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 10:46:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:33742 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbZGXOqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 10:46:55 -0400
Subject: Re: report a bug about sched_rt
From: Peter Zijlstra <peterz@infradead.org>
To: sen wang <wangsen.linux@gmail.com>
Cc: mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <454c71700907240704o32dcdeb3v57845eb9472dd04c@mail.gmail.com>
References: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com>
	 <1248437670.6987.26.camel@twins>
	 <454c71700907240604h4673f117j8ed58b9f2ee54798@mail.gmail.com>
	 <1248441290.6987.52.camel@twins>
	 <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com>
	 <1248442415.6987.56.camel@twins>
	 <454c71700907240644h7469e2a5sfcb57f202a2e184d@mail.gmail.com>
	 <1248443656.6987.61.camel@twins>
	 <454c71700907240704o32dcdeb3v57845eb9472dd04c@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 24 Jul 2009 16:48:29 +0200
Message-Id: <1248446909.6987.110.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-24 at 22:04 +0800, sen wang wrote:

> just one question:
> if cpu is free and there is running state task, how you do?
> schedule the task up? or schedule idle task up?

Well, when an RT group is over the bandwidth limit I don't consider them
runnable. Therefore, failing to find any other tasks, we run the idle
task.
