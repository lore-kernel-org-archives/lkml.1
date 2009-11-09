Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbZKIArf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbZKIArf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 19:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZKIAre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 19:47:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:60432 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZKIAre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 19:47:34 -0500
Date: Sun, 8 Nov 2009 16:48:55 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       Leo Chen <leochen@broadcom.com>
Subject: Re: [PATCH 22/23] sysctl arm: Remove binary sysctl support
Message-ID: <20091108164855.595ec70d@infradead.org>
In-Reply-To: <m1hbt4ipni.fsf@fess.ebiederm.org>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
	<1257682930-31401-22-git-send-email-ebiederm@xmission.com>
	<20091108123422.GA9145@flint.arm.linux.org.uk>
	<m1pr7siqjz.fsf@fess.ebiederm.org>
	<m1hbt4ipni.fsf@fess.ebiederm.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Nov 2009 15:05:05 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> >
> > The practical difference is that /proc support now must be compiled
> > in to support sys_sysctl.
> 
> But thanks for the reminder that I need to go into glibc and fix this
> before we disable the sys_sysctl emulation by default.

how are you dealing with existing glibcs ? Or with static linked
binaries? or.. or ..

breaking a heavily used ABI like this is not going to be pretty
or even sane, no matter which way you hate the current one.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
