Return-Path: <linux-kernel-owner+w=401wt.eu-S1751606AbXBCUr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbXBCUr6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 15:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbXBCUr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 15:47:57 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:36841 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbXBCUr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 15:47:57 -0500
Date: Sat, 3 Feb 2007 21:47:36 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: David Schwartz <davids@webmaster.com>
cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Ban module license tag string termination trick
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKEEJIBFAC.davids@webmaster.com>
Message-ID: <Pine.LNX.4.61.0702032136430.13874@yvahk01.tjqt.qr>
References: <MDEHLPKNGKAHNMBLJOLKEEJIBFAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 3 2007 10:31, David Schwartz wrote:
>
>The way out of the GPL problem is to make clear that it is *not* a 
>copyright enforcement scheme

So why do we have EXPORT_SYMBOL_GPL then, if

  -  there shall be no enforcement (such as requiring modules to carry 
     exactly one MODULE_LICENSE, and it be GPL to access GPL symbols)

  -  EXPORT_SYMBOL_GPL can be circumvented by having multiple 
     MODULE_LICENSE and one of those MODULE_LICENSE is ("GPL")
     [see Bodo's patch]

I think Linus has made a stance on the purpose of _GPL [yup, 
http://lkml.org/lkml/2003/12/4/84 ], and I interpret his words "if you 
need this export, you're clearly doing something that requires the GPL" 
being in conflict with [X].

[X]: """obj-combo += proprietary.o gpldummy.o""" and allowing 
proprietary.c to use GPL symbols just because the combo.ko file contains 
at least one MODULE_LICENSE("GPL").

Note IANAL, more a developer, so please don't flame too much.


Jan
-- 
