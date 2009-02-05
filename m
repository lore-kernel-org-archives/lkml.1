Return-Path: <linux-kernel-owner+w=401wt.eu-S1762191AbZBETxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762191AbZBETxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbZBETxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:53:12 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:50765 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640AbZBETxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:53:11 -0500
Date: Thu, 5 Feb 2009 20:54:59 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Floris Kraak <randakar@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] Kbuild: Enable the gcc flag -Wformat-security (was: Re: [PATCH] Kbuild: Disable the -Wformat-security gcc flag)
Message-ID: <20090205195459.GB2617@uranus.ravnborg.org>
References: <56e1b5710902050047h2c58eec7l812a838491a0256a@mail.gmail.com> <56e1b5710902050057r598f03ddhf3de4aa835071832@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56e1b5710902050057r598f03ddhf3de4aa835071832@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 09:57:28AM +0100, Floris Kraak wrote:
> On Thu, Feb 5, 2009 at 9:47 AM, Floris Kraak <randakar@gmail.com> wrote:
> >
> > Here goes:
> >
> 
> Resend, seems like the earlier patch doesn't quite actually work as
> advertised; -Wformat-security needs -Wformat enabled as well.
> ---
> [PATCH] Kbuild: Enable the gcc flag -Wformat-security

We need to sort out the ~150 warnings you see in your
allyesconfig build before applying this one.
We try to avoid applying patches that increases the warning count
without some effort done to fix it first.

So let see what the other patch end up with.

	Sam
