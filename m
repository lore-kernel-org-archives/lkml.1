Return-Path: <linux-kernel-owner+w=401wt.eu-S965122AbXDAVCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965122AbXDAVCt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 17:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965136AbXDAVCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 17:02:49 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4822 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965122AbXDAVCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 17:02:48 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: Rebuilding and checksumming the Linux kernel
Date: Sun, 1 Apr 2007 14:02:31 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKMEACCLAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <478c16ae0704011156u5a34ae96lfd88a6da16d5726a@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sun, 01 Apr 2007 15:02:44 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sun, 01 Apr 2007 15:02:44 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I'm working on a project with teams spread across the world and we all
> work on the same repository patching the kernel and then integrating
> into a common main branch. Even though we label the source code, we
> would like to make sure that we are all building the same kernel by
> running md5sum on the resulting binary.

> Right now, this is not possible because the kernel includes a
> timestamp and a build number on the binary. What are this timestamps
> used for? Can we just remove them? Is there any other thing that may
> lead to different binaries? (we are using the exact toolchains and
> build machines, so we can assume that the same executable is generated
> if the input source is the same).

I think this is wrong in principle even if you can get it to work in
practice. If you want to all work on the same kernel, then keep a single
copy somewhere that you all work from. There is no reason the same source
code will or should always produce the same output. Compilers are not
generally required to be deterministic.

DS


