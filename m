Return-Path: <linux-kernel-owner+w=401wt.eu-S932778AbXCOTIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbXCOTIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932649AbXCOTH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:07:29 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36655 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbXCOTHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:07:19 -0400
Date: Thu, 15 Mar 2007 11:07:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Klaus Kudielka <klaus.kudielka@gmx.net>
Cc: linux-kernel@vger.kernel.org, ivan@cyclades.com
Subject: Re: [PATCH] fix cyclades.h for x86_64 (and probably others)
Message-Id: <20070315110708.ed5ca541.akpm@linux-foundation.org>
In-Reply-To: <20070314215746.GA7781@mars.oe1kib.ampr.org>
References: <20070314215746.GA7781@mars.oe1kib.ampr.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 14 Mar 2007 22:57:47 +0100 Klaus Kudielka <klaus.kudielka@gmx.net> wrote:
> at least on x86_64 the present cyclades.h is broken due to the wrong size
> of uclong. This affects, of course, both the kernel and the user-level
> utilities. The symptom is that cyzload refuses to load the firmware.
> I also managed to freeze the machine when unloading the module.
> 
> The patch below fixes this in an architecture-independent way.
> I have tested it with 2.6.19 and the driver works fine again with a
> Cyclades-Z on an Athlon 64 X2.

Looks OK, thanks.

It would be nice as a followup patch to simply remove ucchar, uclong and
all that gunk altogether from that driver  and just use u8, u16 etc.

But if you decide to do that, please fix your email client first - it is
replacing tabs with spaces.

