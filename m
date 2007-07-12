Return-Path: <linux-kernel-owner+w=401wt.eu-S934052AbXGLM7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052AbXGLM7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763626AbXGLM7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:59:16 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2174 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763186AbXGLM7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:59:15 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "LKML" <linux-kernel@vger.kernel.org>
Subject: RE: NPTL
Date: Thu, 12 Jul 2007 05:58:20 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKEEOEFDAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
In-Reply-To: <a9e22dff0707120537l1a29de93vdd67f146cf36a120@mail.gmail.com>
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 12 Jul 2007 05:58:49 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 12 Jul 2007 05:58:49 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> So I can say that in linux 'thread' == 'process'?

No. A process can have any number of threads.

> Is kernel routine 'kthread' creating a process?

No, since a process can have more than one thread.

> I'm just thinking on this subject: if to create 'real threads' - will
> it increase performance? Should I ever think in this way?
> When I say 'real thread' - I mean the thread that doen't switch
> context when it's starting to run.

I don't follow.

The kernel sometimes calls a KSE a 'process'. This is largely a legacy from
when there was a one-to-one correspondence between KSEs and processes.
However, this is no longer the case. In Linux, 'KSE' == 'thread'.

DS


