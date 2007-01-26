Return-Path: <linux-kernel-owner+w=401wt.eu-S1161251AbXAZT7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161251AbXAZT7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161244AbXAZT7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:59:18 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52503 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161263AbXAZT7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:59:17 -0500
Date: Fri, 26 Jan 2007 11:59:05 -0800
From: Andrew Morton <akpm@osdl.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
Message-Id: <20070126115905.66940ac9.akpm@osdl.org>
In-Reply-To: <20070125050009.GA8672@srcf.ucam.org>
References: <20061219185223.GA13256@srcf.ucam.org>
	<200612201318.06976.david-b@pacbell.net>
	<20061221012924.GC32625@srcf.ucam.org>
	<200612201904.28681.david-b@pacbell.net>
	<20061221040648.GA1499@srcf.ucam.org>
	<20070125050009.GA8672@srcf.ucam.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007 05:00:09 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> In 2.6.19, support for splitting driver suspend and resume callbacks 
> into interrupt and non-interrupt contexts was added. Unfortunately, this 
> broke /sys/device/.../power/state support for all devices. In the long 
> run, this should be obsoleted by power management support in the 
> individual drivers - however, in the case of network drivers (for 
> example), currently only three drivers implement any sort of useful 
> run-time power management.
> 
> This patch allows the bus driver to check whether a specific driver 
> requires the split. If not, the 2.6.18 functionality is restored. It 
> also alters feature-removals.txt to note that the deprecated 
> functionality should not be removed until a replacement actually exists.

That sounds like material for 2.6.20 as well as for 2.6.19.x.
