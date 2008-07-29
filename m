Return-Path: <linux-kernel-owner+w=401wt.eu-S1759661AbYG2W1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661AbYG2W1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYG2W1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:27:36 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:40465 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYG2W1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:27:36 -0400
Message-ID: <488F99EB.2030808@keyaccess.nl>
Date: Wed, 30 Jul 2008 00:30:03 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Simon Arlott <simon@fire.lp0.eu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [patch 5/3] fastboot: sync the async execution before late_initcall
 and move level 6s (sync) first
References: <20080720085924.122feb2b@infradead.org>	<20080720090041.5924f5ff@infradead.org>	<488F84ED.9010200@keyaccess.nl>	<20080729140434.31022f55@infradead.org>	<488F87AB.9080309@keyaccess.nl> <20080729142123.5164b1a4@infradead.org>
In-Reply-To: <20080729142123.5164b1a4@infradead.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.0 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29-07-08 23:21, Arjan van de Ven wrote:

> On Tue, 29 Jul 2008 23:12:11 +0200
> Rene Herman <rene.herman@keyaccess.nl> wrote:

>> After this patch, there are now 2 flush_workqueue(async_init_wq)
>> calls in do_initcalls. Should the other one remain as well?
> 
> yes because if you don't have any level 7's then you won't hit this
> condition... you need the second one.
> 
> flush_workqueue is cheap for the nothing-in-there case.

Ah, yes.

For what it's worth by the way, I'm running that which is available from 
your fastboot repo (12 patches currently) on top of 2.6.26. Not seen any 
trouble. Nor improvements that I've noticed but this is a rather minimal 
and fast booting kernel/system anyway.

Rene.
