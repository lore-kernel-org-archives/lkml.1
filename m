Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYCMNVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYCMNVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 09:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYCMNVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 09:21:25 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:2301 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752000AbYCMNVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 09:21:25 -0400
Date: Thu, 13 Mar 2008 22:21:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ben Nizette <bn@niasdigital.com>
Cc: Hans-J?rgen Koch <hjk@linutronix.de>, gregkh <gregkh@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] UIO: Implement a UIO interface for the SMX Cryptengine
Message-ID: <20080313132110.GA14422@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ben Nizette <bn@niasdigital.com>,
	Hans-J?rgen Koch <hjk@linutronix.de>, gregkh <gregkh@suse.de>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1205407650.3735.19.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205407650.3735.19.camel@moss.renham>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 10:27:30PM +1100, Ben Nizette wrote:
> This patch implements a UIO interface for the SMX Cryptengine.
> 
> The Cryptengine found on the Nias Digital SMX board is best suited
> for a UIO interface.  It is not wired in to the cryptographic API
> as the engine handles it's own keys, algorithms, everything.  All
> that we know about is that if there's room in the buffer, you can
> write data to it and when there's data ready, you read it out again.
> 
> There isn't necessarily even any direct correlation between data
> going in and data coming out again, the engine may consume or
> generate data all on its own.
> 
> This driver is for proprietary hardware but we're always told to
> submit the drivers anyway; here you are.  :-)
> 
> This is version 4 of this patch and addresses all issues raised by
> Hans-J??rgen Koch and Paul Mundt in their reviews.  Slightly altered
> is Paul's suggestion to use DRV_NAME and DRV_VERSION as the UIO
> version and name.  While at the moment they are the same, there
> is no reason for them to stay that way.  Nevertheless we now at
> least provide a MODULE_VERSION macro to keep modinfo happy.
> 
Looks good to me.
