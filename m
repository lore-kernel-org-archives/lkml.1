Return-Path: <linux-kernel-owner+w=401wt.eu-S1758948AbYJMVTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948AbYJMVTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbYJMVTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:19:17 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:59802 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712AbYJMVTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:19:16 -0400
Subject: Re: 2.6.27 gspca driver fails with Trust WB-1400T
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: patrizio.bassi@gmail.com
Cc: "Kernel," <linux-kernel@vger.kernel.org>
In-Reply-To: <48F3AD5A.2080504@gmail.com>
References: <48F3AD5A.2080504@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 13 Oct 2008 23:21:07 +0200
Message-Id: <1223932867.21717.8.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

man, 13 10 2008 kl. 22:19 +0200, skrev Patrizio Bassi:
> Hi
> 
> i have a Trust 1400T perfectly working on 2.6.26 using external module
> (media-video/gspcav1-20071224 is the gentoo version so it's that day
> snapshot.)
> 
> Upgrading to 2.6.27 kernel, using integrated kernel driver
> 
Does the following text explain it (imagine the text being at the front
page of [2])?

"Historically, there has been a number of different projects ([1], ...),
providing v4l drivers outside of the mainline Linux kernel. If you are
migrating from drivers by such projects, you might need to know a few
things. The drivers provided by this project do not do various color
conversion routines in the kernel, but in a userspace library that we
also provide [3].

This means that programs that use v4l and v4l2 must either be
 - able to do the necessary color conversion themselves,
 - link against our userspace library that provides these
   conversions, or
 - be loaded using an appropriately set LD_PRELOAD environment
   variable."

[1] http://mxhaard.free.fr/
[2] http://linuxtv.org/v4lwiki/index.php/Main_Page
[3] http://linuxtv.org/hg/~hgoede/v4l-dvb


Simon Holm Thøgersen

