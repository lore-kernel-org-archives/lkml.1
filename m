Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206AbYDELBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbYDELBo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 07:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYDELBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 07:01:35 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:33962 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbYDELBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 07:01:35 -0400
Date: Sat, 5 Apr 2008 13:01:02 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Rogier Stam <r_stam3108@yahoo.com>, Russell King <rmk@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [MMC Stack] Partition limitation question
Message-ID: <20080405130102.08c9be93@mjolnir.drzeus.cx>
In-Reply-To: <904538.60285.qm@web33108.mail.mud.yahoo.com>
References: <904538.60285.qm@web33108.mail.mud.yahoo.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008 04:38:04 -0700 (PDT)
Rogier Stam <r_stam3108@yahoo.com> wrote:

> Hi,
> 
> I had a short question about the limitation of max. 8
> partitions in the MMC stack. Before the kernel was
> limited to 256 minor numbers, but I believe this is no
> longer the case (65536 if I recall correctly). Is
> there a way around this 8 partition limitation?
> 

Who in their right mind has more than 8 partitions? :)

> I understand that simply renumbering all minor numbers
> is not really a preferred situation as it would
> require everyone to recreate their device nodes.

Indeed. And some embedded systems might not be able to use 32-bit
device nodes. Russell, do you have any insight to share?

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
