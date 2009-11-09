Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZKIE4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZKIE4B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 23:56:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbZKIE4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 23:56:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:54048 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbZKIE4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 23:56:00 -0500
Date: Sun, 8 Nov 2009 20:57:25 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       Leo Chen <leochen@broadcom.com>
Subject: Re: [PATCH 22/23] sysctl arm: Remove binary sysctl support
Message-ID: <20091108205725.28778016@infradead.org>
In-Reply-To: <m1tyx49y44.fsf@fess.ebiederm.org>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
	<1257682930-31401-22-git-send-email-ebiederm@xmission.com>
	<20091108123422.GA9145@flint.arm.linux.org.uk>
	<m1pr7siqjz.fsf@fess.ebiederm.org>
	<m1hbt4ipni.fsf@fess.ebiederm.org>
	<20091108164855.595ec70d@infradead.org>
	<m1tyx49y44.fsf@fess.ebiederm.org>
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

On Sun, 08 Nov 2009 19:27:07 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> I just took a look and the use in linux threads that I don't warn
> about is used by glibc-2.8 but not by glibc-2.10.  glibc-2.11 has just
> been released. so by next year when the removal is scheduled we are
> looking at multiple releases of glibc that don't use sys_sysctl.  So I
> expect shortly I can warn about all uses of sys_sysctl without anyone
> seeing a warning.

hmmmmm it's still an ABI break, and while you say "oh it's 3 glibcs
ago".. there's the static linking case.

to be honest, I don't think we can ever remove things that are used by
glibc during its startup....

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
