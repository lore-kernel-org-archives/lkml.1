Return-Path: <linux-kernel-owner+w=401wt.eu-S1760908AbXEVGU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908AbXEVGU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 02:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbXEVGUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 02:20:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755955AbXEVGUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 02:20:50 -0400
From: Andi Kleen <ak@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -ak] Fix missing include
Date: Tue, 22 May 2007 08:20:11 +0200
User-Agent: KMail/1.9.1
Cc: LKML <linux-kernel@vger.kernel.org>
References: <1179777839.12708.42.camel@chaos>
In-Reply-To: <1179777839.12708.42.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705220820.11688.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 May 2007 22:03, Thomas Gleixner wrote:
> ftp://firstfloor.org/pub/ak/x86_64/quilt/x86_64-2.6.22-rc2-070521-1.bz2
>
> explodes in various places due to missing defines of __cold. We can't
> rely on the assumption that linux/compiler.h is included magically
> before bug.h is included. Include it explicitely.

Hmm, somehow it worked here. Perhaps longer term it would be a good
idea to turn compiler.h into an -include

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Added thanks

-Andi
