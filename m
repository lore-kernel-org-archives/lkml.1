Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbXFUVOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbXFUVOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 17:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756436AbXFUVO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 17:14:29 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1569 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233AbXFUVO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 17:14:28 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: how about mutual compatibility between Linux's GPLv2 and GPLv3?
Date: Thu, 21 Jun 2007 14:13:36 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEJBEMAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <orlkedjcsz.fsf@oliva.athome.lsd.ic.unicamp.br>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 21 Jun 2007 14:14:06 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 21 Jun 2007 14:14:07 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Alexandre Oliva wrote:

> With a mere permission to combine, I can only enforce these provisions
> over my own code.

What does "my own code" mean when we're talking about derivative works and
code in the codebase influencing the design of later code? Code from one
module gets copied into another. Code in one module influences the design of
code in the kernel. New files are added with pieces from multiple other
files.

Are you seriously suggesting that the Linux kernel source contain code with
various different licenses with an obligation for those who work on the
source too keep track of which licenses apply to bits of code when they work
on them? That seems impossible as a practical matter.

All the kernel code not being available under the same license is a short
term problem. Over time, the code will get so combined and interwoven that
the intersection of all permitted licenses would soon apply to effectively
the entire kernel.

This would be no different from adopting GPLv3. Unless, that is, GPLv3 makes
itself compatible with GPlv2. In which case it would be no different from
doing nothing at all. (Except for all the pain it would cause as people
diligently try to figure out what licenses apply to their code and try not
to borrow code from parts of the kernel that have a different license from
the parts they are working on.)

DS


