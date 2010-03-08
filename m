Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab0CHQcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 11:32:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:42274 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab0CHQcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 11:32:14 -0500
Date: Mon, 8 Mar 2010 08:32:04 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, torvalds@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, dipankar@in.ibm.com, josh@freedesktop.org,
       paulmck@linux.vnet.ibm.com, oleg@redhat.com, akpm@linux-foundation.org,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/4] stop_machine: reimplement using cpuhog
Message-ID: <20100308083204.1300b97a@infradead.org>
In-Reply-To: <1268063603-7425-3-git-send-email-tj@kernel.org>
References: <1268063603-7425-1-git-send-email-tj@kernel.org>
	<1268063603-7425-3-git-send-email-tj@kernel.org>
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

On Tue,  9 Mar 2010 00:53:21 +0900
Tejun Heo <tj@kernel.org> wrote:

> Reimplement stop_machine using cpuhog.  As cpuhogs are guaranteed to
> be available for all online cpus, stop_machine_create/destroy() are no
> longer necessary and removed.

question;
stop_machine pretty much also stops interrupts (it has to, at least for
the users of stop_machine).. do cpu_hogs do this too?

(if they don't, cpu_hogs aren't safe for some of the users of
stop_machine, like code patching etc)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
