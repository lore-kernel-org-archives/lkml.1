Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbZA3IHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbZA3IHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 03:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbZA3IHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 03:07:45 -0500
Received: from mail.gmx.net ([213.165.64.20]:51507 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751300AbZA3IHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 03:07:45 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18nHfYfulwnpUyBJsLMMqguk4pSlXIChMYAjqcg4m
	sfTE+crDWZ8cOV
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
	scheduling
From: Mike Galbraith <efault@gmx.de>
To: Nathanael Hoyle <nhoyle@hoyletech.com>
Cc: Jan Engelhardt <jengelh@medozas.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1233302349.17301.27.camel@localhost>
References: <1233294584.28741.2.camel@localhost>
	 <alpine.LSU.2.00.0901300710200.999@fbirervta.pbzchgretzou.qr>
	 <1233297635.17301.11.camel@localhost>
	 <alpine.LSU.2.00.0901300818580.28427@fbirervta.pbzchgretzou.qr>
	 <1233302349.17301.27.camel@localhost>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 09:07:41 +0100
Message-Id: <1233302861.6061.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 02:59 -0500, Nathanael Hoyle wrote:

> I am running foldingathome under it at the moment, and it seems to be
> improving the situation somewhat, but I still need/want to test with
> Mike's referenced patches.

You will most definitely encounter evilness running SCHED_IDLE tasks in
a kernel without the SCHED_IDLE fixes.

	-Mike

