Return-Path: <linux-kernel-owner+w=401wt.eu-S1762750AbXILBQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762750AbXILBQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 21:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758441AbXILBQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 21:16:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:49781 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbXILBQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 21:16:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hF/LWzcMcYtBO5O47PFbPS5Hy931w57G5yHMnucgWWEjuS+dwqxkcpn4lHxivtK7kcVH5X8j1i423jiyWtvDec4S47xN46G22RKj4037Xkfq3Q6uXIN+gbl31bp8QkUGHD3mq1sUIEXvg23qzZFBqTpqwuHKDtpJ8gYYPZ8lVPI=
Message-ID: <6b8cef970709111816l2e421bf3s55e63274e87fd5e1@mail.gmail.com>
Date: Tue, 11 Sep 2007 21:16:03 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [announce] CFS-devel, performance improvements
Cc: linux-kernel@vger.kernel.org, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Mike Galbraith" <efault@gmx.de>,
       "Roman Zippel" <zippel@linux-m68k.org>
In-Reply-To: <20070911200459.GA6974@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070911200459.GA6974@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

When compiling, I get:
In file included from kernel/sched.c:794:
kernel/sched_fair.c: In function 'task_new_fair':
kernel/sched_fair.c:857: error: 'sysctl_sched_child_runs_first'
undeclared (first use in this function)
kernel/sched_fair.c:857: error: (Each undeclared identifier is
reported only once
kernel/sched_fair.c:857: error: for each function it appears in.)

Presumably because sched_fair.c is being included into sched.c before
sysctl_sched_child_runs_first is defined.

Regards,
Rob
