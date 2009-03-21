Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbZCUKUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbZCUKUs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 06:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbZCUKUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 06:20:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:33139 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZCUKUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 06:20:38 -0400
Subject: Re: [tip:core/ipi] generic-ipi: eliminate spurious
 pointlessWARN_ON()s
From: Peter Zijlstra <peterz@infradead.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1zlff227g.fsf@fess.ebiederm.org>
References: <49B91A7E.76E4.0078.0@novell.com>
	 <tip-6a09dfa870ba0ed21b1124539968a36b42660661@git.kernel.org>
	 <1236934491.5188.209.camel@laptop> <49BA33BE.76E4.0078.0@novell.com>
	 <1236937423.22914.3698.camel@twins> <20090313103828.GB31094@elte.hu>
	 <m1d4cd9n4k.fsf@fess.ebiederm.org> <20090320085205.GB16021@elte.hu>
	 <m14oxo8qis.fsf@fess.ebiederm.org> <20090320182404.GA31629@elte.hu>
	 <1237575134.4667.5.camel@laptop>  <m1zlff227g.fsf@fess.ebiederm.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 21 Mar 2009 11:20:06 +0100
Message-Id: <1237630806.24626.104.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 16:40 -0700, Eric W. Biederman wrote:
> It doesn't look like read==2 works properly because it does not log any
> locks grabbed underneath the reader lock.  Is that deliberate?  It certainly
> does not seem to be correct.

You're right, it doesn't work correctly. One of the patches in that heap
I pointed you at tries to fix it, but gets it wrong.
