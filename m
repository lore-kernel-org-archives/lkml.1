Return-Path: <linux-kernel-owner+w=401wt.eu-S1760572AbYEHGtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760572AbYEHGtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 02:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbYEHGsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 02:48:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757347AbYEHGsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 02:48:52 -0400
Date: Wed, 7 May 2008 23:48:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-Id: <20080507234824.f097f96d.akpm@linux-foundation.org>
In-Reply-To: <20080508064340.GA27452@elte.hu>
References: <1210052904.3453.30.camel@ymzhang>
	<20080506114449.GC32591@elte.hu>
	<1210126286.3453.37.camel@ymzhang>
	<1210131712.3453.43.camel@ymzhang>
	<87lk2mbcqp.fsf@basil.nowhere.org>
	<20080507114643.GR19219@parisc-linux.org>
	<87hcdab8zp.fsf@basil.nowhere.org>
	<alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org>
	<alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org>
	<1210214696.3453.87.camel@ymzhang>
	<20080508064340.GA27452@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008 08:43:40 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> great! Yanmin, could you please also check the other patch i sent (also 
> attached below), does it solve the regression similarly?
> 
> 	Ingo
> 
> ---
>  lib/kernel_lock.c |    9 ++++++---

but but but.  Some other users of down() have presumably also regressed.  We just
have't found the workload to demonstrate that yet.

