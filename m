Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbZLTSPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbZLTSPU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 13:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755558AbZLTSPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 13:15:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:43863 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480AbZLTSPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 13:15:18 -0500
Date: Sun, 20 Dec 2009 19:17:25 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>, San Mehat <san@google.com>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: sched: restore sanity
Message-ID: <20091220191725.1799eab7@infradead.org>
In-Reply-To: <1261329743.30458.179.camel@Joe-Laptop.home>
References: <1261315437.4314.6.camel@laptop>
	<20091220144925.GA19608@elte.hu>
	<1261320715.4314.9.camel@laptop>
	<236ccac0912200703g464912b1r421497ebf3b6ebc6@mail.gmail.com>
	<236ccac0912200705i369d00d1v42603a00e92039b6@mail.gmail.com>
	<1261322387.4314.22.camel@laptop>
	<1261329743.30458.179.camel@Joe-Laptop.home>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Dec 2009 09:22:23 -0800
Joe Perches <joe@perches.com> wrote:

> What are the negatives of using pr_<level>?

pr_ is really just for "I am a driver and want a single line message
out in a standardized format".
Nothing wrong with that.

But here you are changing fundamental kernel outputs in the style of an
oops message. Multiline, complex and machine parsed things...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
