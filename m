Return-Path: <linux-kernel-owner+w=401wt.eu-S1762951AbXJZSH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762951AbXJZSH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762455AbXJZSH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:07:27 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1813 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762147AbXJZSH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:07:26 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Is gcc thread-unsafe?
Date: Fri, 26 Oct 2007 11:06:13 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKCELIHMAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <18210.2314.57767.962503@zebedee.pink>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Fri, 26 Oct 2007 11:07:15 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Fri, 26 Oct 2007 11:07:17 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Well, yeah.  I know what you mean.  However, at this moment, some gcc
> developers are trying really hard not to be total d*ckheads about this
> issue, but get gcc fixed.  Give us a chance.
>
> Andrew.

Can we get some kind of consensus that 'optimizations' that add writes to
any object that the programmer might have taken the address of are invalid
on any platform that supports memory protection? That seems like obvious
common sense to me.

And it has the advantage that it can't be language-lawyered. There is no
document that states the rational requirements of a compiler that's going to
support a memory protection model. So they can be anything rational people
think they should be.

DS


