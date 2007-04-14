Return-Path: <linux-kernel-owner+w=401wt.eu-S1161178AbXDNLjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161178AbXDNLjE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 07:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161187AbXDNLjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 07:39:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:53133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161178AbXDNLjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 07:39:03 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: 2.6.21-rc6 + firstfloor patches: BUG: sleeping function called from invalid context at kernel/sched,.c:3643
Date: Sat, 14 Apr 2007 13:38:49 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <462072C2.4070605@goop.org>
In-Reply-To: <462072C2.4070605@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704141338.50058.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 April 2007 08:20:50 Jeremy Fitzhardinge wrote:
> I'm seeing this:
> 
> Apr 13 21:55:34 localhost kernel: BUG: sleeping function called from invalid context at kernel/sched.c:3643

Fixed now. The latest sched-clock was leaking preempt counts during
cpu frequency changes.

-Andi
