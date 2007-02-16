Return-Path: <linux-kernel-owner+w=401wt.eu-S1161503AbXBPD2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161503AbXBPD2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 22:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161716AbXBPD2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 22:28:39 -0500
Received: from ozlabs.org ([203.10.76.45]:59945 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161503AbXBPD2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 22:28:38 -0500
Subject: Re: [patch 2.6.20-git] remove modpost false warnings on ARM
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       kai@germaschewski.name, Russell King <rmk@arm.linux.org.uk>,
       sam@ravnborg.org
In-Reply-To: <200702151910.46397.david-b@pacbell.net>
References: <200701120831.37513.david-b@pacbell.net>
	 <200702151910.46397.david-b@pacbell.net>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 14:28:04 +1100
Message-Id: <1171596485.26672.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-15 at 19:10 -0800, David Brownell wrote:
> This patch stops "modpost" from issuing erroneous modpost warnings on ARM
> builds, which it's been doing since since maybe last summer.  A canonical
> example would be driver method table entries:
> 
>   WARNING: <path> - Section mismatch: reference to .exit.text:<name>_remove
> 	from .data after '$d' (at offset 0x4)

Looks fine to me.

Rusty.


