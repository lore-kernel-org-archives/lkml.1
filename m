Return-Path: <linux-kernel-owner+w=401wt.eu-S932657AbXGLM15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657AbXGLM15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757486AbXGLM1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:27:51 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4418 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399AbXGLM1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:27:50 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "LKML" <linux-kernel@vger.kernel.org>
Subject: RE: NPTL
Date: Thu, 12 Jul 2007 05:27:31 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKCEOCFDAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
In-Reply-To: <a9e22dff0707120518t77d440d3ue0368fd1f3e36c03@mail.gmail.com>
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 12 Jul 2007 05:28:03 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 12 Jul 2007 05:28:04 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi!
> I have a question about NPTL.
> Are NPTL are still based on `clone` system call?

Yes.

> Are NPTL threads are
> "processes" internally?

No. By definition, all the threads belong to a single process. NPTL threads
are based on KSEs (kernel scheduling entities). A non-threaded process is
also a KSE. A threaded process is more than one KSEs. All KSE are,
obviously, scheduled by the kernel.

> Thanks!

You're welcome.

DS


