Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbXC3VQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbXC3VQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbXC3VQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:16:06 -0400
Received: from smtp.osdl.org ([65.172.181.24]:53107 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbXC3VPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:15:35 -0400
Date: Fri, 30 Mar 2007 14:15:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ken Chen" <kenchen@google.com>
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] remove artificial software max_loop limit
Message-Id: <20070330141524.5f6cff29.akpm@linux-foundation.org>
In-Reply-To: <b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com>
References: <b040c32a0703300053u110063b0u80ee0e7b9dd158c2@mail.gmail.com>
	<b040c32a0703300148w479cf4cdw667cf464edf7c725@mail.gmail.com>
	<Pine.LNX.4.61.0703301105190.31834@yvahk01.tjqt.qr>
	<b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007 02:25:37 -0700
"Ken Chen" <kenchen@google.com> wrote:

> -module_param(max_loop, int, 0);
> -MODULE_PARM_DESC(max_loop, "Maximum number of loop devices (1-256)");

So..  this change will cause a fatal error for anyone who is presently
using max_loop, won't it?  If they're doing that within their
initramfs/initrd/etc then things could get rather ugly for them.

I don't know how much of a problem this will be in practice - do people use
max_loop much?

btw, did you test this change as both a module and as linked-into-vmlinux?
