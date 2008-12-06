Return-Path: <linux-kernel-owner+w=401wt.eu-S1757767AbYLFKLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbYLFKLQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 05:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbYLFKLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 05:11:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48225 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbYLFKK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 05:10:59 -0500
Date: Sat, 6 Dec 2008 08:10:40 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com
Subject: Re: linux-next: Tree for December 3 (media/video/cx88)
Message-ID: <20081206081040.79b8dd44@pedra.chehab.org>
In-Reply-To: <4936F718.2000101@oracle.com>
References: <20081203183602.c06f8c39.sfr@canb.auug.org.au>
	<4936F718.2000101@oracle.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Wed, 03 Dec 2008 13:16:08 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> CONFIG_VIDEO_CX88=y
> CONFIG_VIDEO_CX88_DVB=m

That's the issue: cx18-dvb shouldn't be a module, since it depends on cx88.
I'll take a look at the kconfig stuff to solve this issue.

Thanks for reporting!

Cheers,
Mauro
