Return-Path: <linux-kernel-owner+w=401wt.eu-S1752859AbXCQSzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbXCQSzZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 14:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbXCQSzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 14:55:24 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35822 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbXCQSzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 14:55:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, containers@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + remove-the-likelypid-check-in-copy_process.patch added to -mm tree
References: <20070316170255.GA194@tv-sign.ru>
	<m1y7lxm4cc.fsf@ebiederm.dsl.xmission.com>
	<20070317130216.GA78@tv-sign.ru>
	<m1k5xgklun.fsf@ebiederm.dsl.xmission.com>
	<20070317150949.GA302@tv-sign.ru> <20070317152437.GA365@tv-sign.ru>
	<m1fy83ls75.fsf@ebiederm.dsl.xmission.com>
	<20070317171747.GA134@tv-sign.ru>
Date: Sat, 17 Mar 2007 12:54:11 -0600
In-Reply-To: <20070317171747.GA134@tv-sign.ru> (Oleg Nesterov's message of
	"Sat, 17 Mar 2007 20:17:47 +0300")
Message-ID: <m1bqirlmzw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> Yes! I meant we should change INIT_SIGNALS(), currently it does
>
> 	#define INIT_SIGNALS(sig) {
> 		...
> 		.pgrp           = 1,
> 		{ .__session      = 1},
>
> and this confuses (I think) set_special_pids(1,1) above. Because
> __set_special_pids() still deals with pid_t, not "struct pid".
>
> Unless I missed something, we should kill these 2 initializations
> above.

Got it.  I agree we should initialize those fields to 0.

Sukadev you want to get that?

Eric
