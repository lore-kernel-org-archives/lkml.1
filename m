Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098AbXCRGuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbXCRGuk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 02:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbXCRGuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 02:50:40 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:46900 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbXCRGuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 02:50:39 -0400
Date: Sat, 17 Mar 2007 23:50:36 -0700
From: sukadev@us.ibm.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Cedric Le Goater <clg@fr.ibm.com>,
       Dave Hansen <haveblue@us.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       containers@lists.osdl.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: + remove-the-likelypid-check-in-copy_process.patch added to -mm tree
Message-ID: <20070318065036.GB32402@us.ibm.com>
References: <20070316170255.GA194@tv-sign.ru> <m1y7lxm4cc.fsf@ebiederm.dsl.xmission.com> <20070317130216.GA78@tv-sign.ru> <m1k5xgklun.fsf@ebiederm.dsl.xmission.com> <20070317150949.GA302@tv-sign.ru> <20070317152437.GA365@tv-sign.ru> <m1fy83ls75.fsf@ebiederm.dsl.xmission.com> <20070317171747.GA134@tv-sign.ru> <m1bqirlmzw.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bqirlmzw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman [ebiederm@xmission.com] wrote:
| Oleg Nesterov <oleg@tv-sign.ru> writes:
| 
| > Yes! I meant we should change INIT_SIGNALS(), currently it does
| >
| > 	#define INIT_SIGNALS(sig) {
| > 		...
| > 		.pgrp           = 1,
| > 		{ .__session      = 1},
| >
| > and this confuses (I think) set_special_pids(1,1) above. Because
| > __set_special_pids() still deals with pid_t, not "struct pid".
| >
| > Unless I missed something, we should kill these 2 initializations
| > above.
| 
| Got it.  I agree we should initialize those fields to 0.
| 
| Sukadev you want to get that?

Sure. Will do that.

Thanks Oleg for your detailed review/comments.

Suka
