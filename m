Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbXEXWTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbXEXWTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbXEXWTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:19:47 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48839 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752390AbXEXWTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:19:46 -0400
Date: Thu, 24 May 2007 15:19:45 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
cc: Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <82244.99748.qm@web52603.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0705241516330.32086@schroedinger.engr.sgi.com>
References: <82244.99748.qm@web52603.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007, Srihari Vijayaraghavan wrote:

> I know slabinfo_without_v might not be good enough for you. For completeness,
> I attach it here anyway.

Right. "slabinfo" output is useless. You need to specify -v for it to have 
any effect.

slabinfo -v

can detect object corruptions without the kernel having to touch the 
object. It will scan all objects and it will only work if run as root.
Any corrupted objects will be reported to the syslog.

